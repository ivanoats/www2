module Formz #:nodoc:
  module LabeledInstanceTag #:nodoc:
    def to_label_tag2(options = {})
      options = options.stringify_keys
      add_default_name_and_id(options)
      options.delete('name')
      options['for'] = options.delete('id')
      tooltip = " #{options.delete('tooltip')}"
      content_tag 'label', (options.delete('required') ? "<em>*</em> " : "") + ((options.delete('text') || @method_name.titleize) + tooltip), options
    end
  end

  module FormBuilderMethods #:nodoc:
    def label_for(method, options = {})
      @template.label_for(@object_name, method, options.merge(:object => @object))
    end
  end

  class FormzBuilder < ActionView::Helpers::FormBuilder #:nodoc:
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TagHelper
    
    (%w(date_select) + ActionView::Helpers::FormHelper.instance_methods - %w(label_for hidden_field form_for fields_for file_field)).each do |selector|      
      field_class =
        case selector
          when "text_field": "textInput"
          when "password_field": "textInput"
          else ""
        end
      src = <<-end_src
        def #{selector}(method, options = {})
          render_field(method, options, super(method, clean_options({:class => '#{field_class}'}.merge(options))))        
        end
      end_src
      class_eval src, __FILE__, __LINE__
    end
    
    #guess field to use based on column type, can be overwritten with :type
    def field(method, options = {})
      options.stringify_keys
      type = options.delete('type') || @object.column_for_attribute(method.to_s).type
      
      case type
      when :string, :integer, :float
        text_field(method, options)
      when :text
        text_area(method, options)
      when :datetime
        datetime_select(method,options)
      when :date
        date_select(method,options)
      when :time
        time_select(method,options)
      when :boolean
        check_box(method, options)
      else 
        "Unknown field type #{type.to_s}"
      end
    end
    
    #pass in multiple field names to generate the default field for them
    def fields(names)
      names.each { |name| @template.concat(field(name)) }
      ''
    end
    
    #render a labeled field with custom contents 
    def custom_field(label, contents)
      render_field(label, {}, contents)
    end
    
    
    def file_field(method,options = {})
      file = @object.send method
      
      display = render_field(method, options, super(method, clean_options({:class => 'fileInput'}.merge(options))))    
      if file
        if file.image? && file.responds_to(:public_filename)
          display = image_tag(file.public_filename(:thumb)) + display
        else
          display = link_to(file.filename,file.public_filename) + display
        end
      end
      
      display
    end
    
    
    
    def multi_field( label, sublabel = '', &proc )
      raise ArgumentError, "Missing block" unless block_given?
      label_id = sanitize_to_id("#{label}_multifield")
      @multi_field = true
        content = @template.label_tag(label_id, label) + sublabel + @template.content_tag(:div,@template.capture(&proc), {:class => 'zMultiFieldContainer', :id => label_id})
        @template.concat(@template.content_tag(:div, content, :class => 'zMultiField'))
      @multi_field = nil
    end
    
    def row( options = {}, &proc )
      raise ArgumentError, "Missing block" unless block_given?
      @row = true
        @field_count = 0
        content = @template.capture(&proc)
      @row = false
      options[:class] = "#{options[:class]} zInlineField"
      @template.concat(@template.content_tag(:div, content, :class => (options[:inline] ? "zInlineRow" : "zRow zRowFields#{@field_count}")))
    end
    
    def name
      multi_field 'Name' do
        row do
          text_field( :first_name, :label => "First") + 
          text_field( :last_name, :label => "Last")
        end
      end
    end

    def phone_number
      self.object.phone_number ||= PhoneNumber.new
      fields_for :phone_number do |phone|
        phone.multi_field 'Phone Number' do
          phone.row(:inline => true) do
            phone.text_field( :number_1, :size => 3, :maxlength => 3, :label => '', :style => 'width: 2em; margin-right: 3px', :value => "#{self.object.phone_number.number_1}") + 
            phone.text_field( :number_2, :size => 3, :maxlength => 3, :label => '', :style => 'width: 2em; margin-right: 3px', :value => "#{self.object.phone_number.number_2}") + 
            phone.text_field( :number_3, :size => 4, :maxlength => 4, :label => '', :style => 'width: 3em', :value => "#{self.object.phone_number.number_3}" )          
          end
        end
      end
    end
    
    def address(options = {})
      options = {:label => "Address"}.merge( options.stringify_keys)
      
      multi_field options['label'] do
        row :style => 'width: 100%' do
          text_area :street, :class => 'street'
        end
        row do
          text_field :city
        end
        row do
          if ActiveRecord::Base.connection.tables.include?(:states)
            select(:state_id, [[' ',0]] + State.find(:all, :order => :name).collect { |s| [s.name,s.id]}) + text_field( :zip )
          else
            select(:state, [   
              [' ', ''],
                ['Alabama', 'AL'], 
                ['Alaska', 'AK'],
                ['Arizona', 'AZ'],
                ['Arkansas', 'AR'], 
                ['California', 'CA'], 
                ['Colorado', 'CO'], 
                ['Connecticut', 'CT'], 
                ['Delaware', 'DE'], 
                ['District Of Columbia', 'DC'], 
                ['Florida', 'FL'],
                ['Georgia', 'GA'],
                ['Hawaii', 'HI'], 
                ['Idaho', 'ID'], 
                ['Illinois', 'IL'], 
                ['Indiana', 'IN'], 
                ['Iowa', 'IA'], 
                ['Kansas', 'KS'], 
                ['Kentucky', 'KY'], 
                ['Louisiana', 'LA'], 
                ['Maine', 'ME'], 
                ['Maryland', 'MD'], 
                ['Massachusetts', 'MA'], 
                ['Michigan', 'MI'], 
                ['Minnesota', 'MN'],
                ['Mississippi', 'MS'], 
                ['Missouri', 'MO'], 
                ['Montana', 'MT'], 
                ['Nebraska', 'NE'], 
                ['Nevada', 'NV'], 
                ['New Hampshire', 'NH'], 
                ['New Jersey', 'NJ'], 
                ['New Mexico', 'NM'], 
                ['New York', 'NY'], 
                ['North Carolina', 'NC'], 
                ['North Dakota', 'ND'], 
                ['Ohio', 'OH'], 
                ['Oklahoma', 'OK'], 
                ['Oregon', 'OR'], 
                ['Pennsylvania', 'PA'], 
                ['Rhode Island', 'RI'], 
                ['South Carolina', 'SC'], 
                ['South Dakota', 'SD'], 
                ['Tennessee', 'TN'], 
                ['Texas', 'TX'], 
                ['Utah', 'UT'], 
                ['Vermont', 'VT'], 
                ['Virginia', 'VA'], 
                ['Washington', 'WA'], 
                ['West Virginia', 'WV'], 
                ['Wisconsin', 'WI'], 
                ['Wyoming', 'WY']], :class => 'state')
          end + text_field( :zip )
          
        end
      end
    end
      
    def submit(value = "Save changes", options = {})
      options.stringify_keys!
      if disable_with = options.delete("disable_with")
        options["onclick"] = "this.disabled=true;this.value='#{disable_with}';this.form.submit();#{options["onclick"]}"
      end

      @template.content_tag :div, 
      options['prefix'].to_s + @template.content_tag(:button, @template.content_tag(:span,value), { "type" => "submit", "name" => "commit", :class => "submitButton button"}.update(options.stringify_keys)), 
        :class => "buttonHolder"
    end
    
    def radio_button(method, tag_value, options = {})
      render_field(method, options, super(method, tag_value, options))
    end
    
    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      render_field(method, options, super(method, collection, value_method, text_method, options, html_options.merge(:class => "selectInput")))
    end    
    
    def select(method, choices, options = {}, html_options = {})
      render_field(method, options, super(method, choices, options, html_options.merge(:class => "selectInput")))
    end
    
    def country_select(method, priority_countries = nil, options = {}, html_options = {})
      render_field(method, options, super(method, priority_countries, options, html_options.merge(:class => "selectInput")))
    end
    
    def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
      render_field(method, options, super(method, priority_zones, options, html_options.merge(:class => "selectInput")))
    end
    
    def hidden_field(method, options={})
      super
    end
    
    def select_month(method, options = {}, html_options = {})
      month = Time.now.month
      render_field(method,options, @template.select_month(month,options, html_options))
    end
    
    def select_year(method, options = {}, html_options = {})
      year = Time.now.year
      render_field(method, options, @template.select_year(year, options, html_options))
    end
    
    def date_select(method, options = {}, html_options = {})
      render_field(method,options,@template.date_select(@object_name, method, options.merge(:object => @object),html_options.merge(:class => 'selectInput selectInputInline')))
    end

    def time_select(method, options = {}, html_options = {})
      render_field(method,options,@template.time_select(@object_name, method, options.merge(:object => @object),html_options.merge(:class => 'selectInput selectInputInline')))
    end

    def datetime_select(method, options = {}, html_options = {})
      render_field(method,options,@template.datetime_select(@object_name, method, options.merge(:object => @object),html_options.merge(:class => 'selectInput selectInputInline')))
    end
    
    def fieldset(*args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      options = args.last.is_a?(Hash) ? args.pop : {}
      
      #classname = options[:type] == "inline" ? "inlineLabels" : "blockLabels"  
      
      content =  @template.capture(&proc)
      content = @template.content_tag(:legend, options[:legend]) + content if options.has_key? :legend
      
      classname = options[:class]
      classname = "" if classname.nil?
      classname << " " << (options[:type] == "inline" ? "inlineLabels" : "blockLabels")

      options.delete(:legend)
      options.delete(:type)
      @fieldset = true
      @template.concat(@template.content_tag(:fieldset, content, options.merge({ :class => classname.strip })))
      @fieldset = false      
    end

    def error_messages(options={})
      obj = @object || @template.instance_variable_get("@#{@object_name}")
      count = obj.errors.count
      unless count.zero?
        html = {}
        [:id, :class].each do |key|
          if options.include?(key)
            value = options[key]
            html[key] = value unless value.blank?
          else
            html[key] = 'errorMsg'
          end
        end
        header_message = "Ooops!"
        error_messages = obj.errors.full_messages.map {|msg| @template.content_tag(:li, msg) }
        @template.content_tag(:div,
          @template.content_tag(options[:header_tag] || :h3, header_message) <<
            #@template.content_tag(:p, 'There were problems with the following fields:') <<
            @template.content_tag(:ul, error_messages),
          html
        )
      else
        ''
      end
    end
    
    def info_message(options={})
      sym = options[:sym] || :zform_message
      @template.flash[sym] ? @template.content_tag(:p, @template.flash[sym], :id => "OKMsg") : ''
    end
    
    def messages
       error_messages + info_message
    end
    
private
    
    def render_field(method, options, field_tag, base_label_options = {})
      label_options = { :required => options.delete(:required)}
      label_options.update(base_label_options)
      label_options.update(:text => options.delete(:label)) if options.has_key? :label
      label_options.update(:tooltip => options.delete(:tooltip)) if options.has_key? :tooltip
      before = options.delete( :before ) || ""
      after = options.delete(:after) || ""
      plain = options.delete(:plain)
      hint = options.delete( :hint )
      no_div = options.delete(:no_div)
      
      errors = object ? object.errors.on(method) : nil

      divContent = errors.nil? ? "" : @template.content_tag('p', errors.class == Array ? errors.first : errors, :class => "errorField")
    
      divContent = ""
      
      wrapperClass = ' '
      wrapperClass << ' col' if options.delete(:column)
      wrapperClass << options.delete(:ctrl_class) if options.has_key? :ctrl_class
      wrapperClass << ' error' if not errors.nil?
      
      label = @multi_field ? @template.content_tag('span',(label_options[:text] || method).to_s.titleize,:class => 'zInlineLabel') : label_for(method, label_options)
      label = "" if options[:no_label]
      
      field_tag = @template.content_tag('div', field_tag, :class => 'zFieldDiv') unless no_div
      
      if options[:reverse]
        divContent << before << field_tag << label << after
      else
        divContent << before << label << field_tag << after
      end
      divContent << @template.content_tag('p', hint, :class => 'formHint') if not hint.blank?
            
      @field_count+= 1 if @row
         
      if plain
        field_tag
      elsif not (@fieldset || @multi_field)
        @template.content_tag('div', divContent, :class => "zField #{wrapperClass}")
      elsif @multi_field
        @template.content_tag(:span,divContent, :class => "zInlineField #{wrapperClass}")
      else
        divContent
      end
    end
    
    def clean_options(options)
      options.reject { |key, value| key == :required or key == :label or key == :hint or key == :column or key == :ctrl_class}
    end
    
  end
end
