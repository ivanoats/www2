module TableHelper
  
  def model_table(records, options = {}, &block)
    html = options[:html] || {}
    html[:class] = "model_table"
    
    _out = tag('table', {:id => html[:id], :class => html[:class]}, true) 
    _out << tag('tbody', nil, true) 
    _out << tag('tr', nil, true)    
    
    if options[:fields]
      _inner = ""
      content_tag('tr') do
        options[:fields].each {|field|
          _inner << content_tag('th',field.to_s.humanize)
        }
      _out << _inner
      end
    end
    
    records.each { |record|
      _out << content_tag('tr', :class => cycle("odd","even")) do
        block.call( record )
      end
    }

    _out << '</tr></tbody></table>'
    concat(_out)
    nil
  end
  
      # 
      #   index = 0
      #   size = collection.size
      #   empty_cell = content_tag('td', '&nbsp;', :class => 'blank')
      #   # add header
      #   if (opts[:header]) 
      #     _out << content_tag('th', opts[:header])
      #     index += 1
      #     size += 1
      #   end
      #   # fill line with items, breaking if needed
      #   collection.each do |item|
      #     index += 1
      #     _out << content_tag('td', capture(item, &block))
      #     should_wrap =  index.remainder(columns) == 0 and index != size
      #     _out << '</tr>' << tag('tr', nil, true) if should_wrap 
      #     
      #     # prepend every line with an empty cell
      #     if should_wrap && opts[:skip_header_column] == true
      #       _out << empty_cell 
      #       index += 1; size += 1
      #     end
      #   end
      #   # fill remaining columns with empty boxes
      #   remaining = size.remainder(columns)
      #    (columns - remaining).times do
      #     _out << empty_cell
      #   end unless remaining == 0
      #   _out << '</tr>' << '</tbody>' << '</table>' 
      #   concat(_out, block.binding)
      #   nil # avoid duplication if called with <%= %>
      # end
    
end