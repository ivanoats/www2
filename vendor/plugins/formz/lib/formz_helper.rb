module Formz
  module FormzHelper
    
    def formz_stylesheets
      ["zform", "zform/block", "zform/inline", "zform/fields"]
    end
    
    def formz_javascripts
      ActionView::Helpers::PrototypeHelper.const_defined?("JQCALLBACKS") ? "zform.jquery.js" : "zform.prototype.js"
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
  end
end

module ActionView::Helpers::FormHelper
  
  def apply_form_for_options_with_spinner!(object,options)
    if(options.delete(:spinner))
      spinner_id = "spinner_#{object.id}_#{ActionController::RecordIdentifier.singular_class_name(object)}"
      options.merge!({:before => "jQuery('##{spinner_id}').show();", :complete => "jQuery('##{spinner_id}').hide();"})
    end
    apply_form_for_options_without_spinner!(object,options)    
  end
  alias_method_chain :apply_form_for_options!, :spinner 

end