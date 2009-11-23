module SpinnerHelper
  
  def spinner_image(id = 'ajax_loader') 
    content_tag(:div,image_tag('ajax-loader.gif', :id => id, :style => ' display:none'), :style => 'padding: 5px;')
  end
  
  def show_hide_spinner(id = 'ajax_loader')
    {:before => "jQuery('##{id}').show();", :complete => "jQuery('##{id}').hide();",}
  end
  
end
