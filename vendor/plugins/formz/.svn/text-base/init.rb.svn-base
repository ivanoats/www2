require 'formz'
require 'formz_helper'

ActionView::Base.send                 :include, Formz::FormzHelper
ActionView::Helpers::InstanceTag.send :include, Formz::LabeledInstanceTag
ActionView::Helpers::FormBuilder.send :include, Formz::FormBuilderMethods

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
#  if html_tag =~ /<(input)[^>]+type=["'](radio|checkbox|hidden|label)/
#    html_tag
#  else
#    "<div class=\"error\">#{html_tag}</div>"
#  end
end
