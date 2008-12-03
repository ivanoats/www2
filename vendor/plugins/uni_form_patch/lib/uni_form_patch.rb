module UniFormPatch

  def uniform_error_messages objects
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

  def uniform_success_message msg
    content_tag("div", content_tag("h3", msg), :id => "successMsg")
  end
  
end
