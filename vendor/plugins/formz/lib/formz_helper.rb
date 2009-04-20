module Formz
  
  module FormzHelper
    
    def formz_stylesheets
      ["zform", "zform/block", "zform/inline", "zform/fields"]
    end
    
    def formz_javascripts
      ActionView::Helpers::PrototypeHelper.const_defined?( :JQCALLBACKS ) ? "zform.jquery.js" : "zform.prototype.js"
    end
    
    [:form_for, :fields_for, :form_remote_for, :remote_form_for].each do |meth|
        src = <<-end_src
          def z_#{meth}(object_name, *args, &proc)
            options = args.last.is_a?(Hash) ? args.pop : {}
            html_options = options.has_key?(:html) ? options[:html] : {}
            if html_options.has_key?(:class) 
              html_options[:class] << ' zForm'
            else
              html_options[:class] = 'zForm'
            end
            options.update(:html => html_options)
            options.update(:builder => FormzBuilder)
            #{meth}(object_name, *(args << options), &proc)
          end
        end_src
        module_eval src, __FILE__, __LINE__
      end
      

    def label_for(object_name, method, options = {})
      options[:text] ||= method.to_s.titleize
      ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_label_tag2(options)
    end

   def zform_error_messages objects
     no_error = true
     str = ""
     objects.each do |object|
       no_error = no_error && object.errors.empty?
       object.errors.each do |attr, msg|
           str << content_tag("li", "#{object.class.human_attribute_name(attr)} #{msg}")
       end
     end
     return content_tag("div", content_tag("h3", "Ooops! We Have a Problem.") + content_tag("ol", str), :id => "errorMsg") unless no_error
     ""
   end

   def zform_success_message msg
     content_tag("div", content_tag("h3", msg), :id => "successMsg")
   end
   
   
  end

end