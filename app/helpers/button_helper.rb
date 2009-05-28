module ButtonHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::TagHelper
  
  def button_to_remote_with_button(name, options = {}, html_options  = {})
    if(options[:button])
      button_to_remote_without_button(name, options.reverse_merge(:method => :post), html_options.reverse_merge(:class => 'button'))
    else
      button_to_remote_without_button(name, options, html_options)
    end
  end
  alias_method_chain :button_to_remote, :button

  def button(name, url = nil, options = {})
    link_to(content_tag(:span,name), url, options.reverse_merge(:class => 'button', :onclick => "this.blur()"))
  end
  
  def button_to_function(name, *args, &block)
    html_options = args.extract_options!.symbolize_keys
  
    function = block_given? ? update_page(&block) : args[0] || ''
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function};"
  
    content_tag(:button, content_tag(:span,name), html_options.merge(:type => 'button', :onclick => onclick))
  end
  
  def submit_tag(value = "Save changes", options = {})
    options.stringify_keys!
  
    if disable_with = options.delete("disable_with")
      disable_with = "this.value='#{disable_with}'"
      disable_with << ";#{options.delete('onclick')}" if options['onclick']
      
      options["onclick"]  = "if (window.hiddenCommit) { window.hiddenCommit.setAttribute('value', this.value); }"
      options["onclick"] << "else { hiddenCommit = this.cloneNode(false);hiddenCommit.setAttribute('type', 'hidden');this.form.appendChild(hiddenCommit); }"
      options["onclick"] << "this.setAttribute('originalValue', this.value);this.disabled = true;#{disable_with};"
      options["onclick"] << "result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit());"
      options["onclick"] << "if (result == false) { this.value = this.getAttribute('originalValue');this.disabled = false; }return result;"
    end
  
    if confirm = options.delete("confirm")
      options["onclick"] ||= ''
      options["onclick"] << "return #{confirm_javascript_function(confirm)};"
    end
  
    content_tag( :button, content_tag(:span, value), { "class" => "button", "type" => "submit", "name" => "commit", "value" => value }.update(options.stringify_keys))
  end
  
end