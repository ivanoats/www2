module DisplayHelper
  
  def display_address(address = nil)
    return unless address
    
    city_state_zip = h address.city
    city_state_zip += ', ' + h( address.state) unless address.state
    city_state_zip += ' ' + h( address.zip)
    content_tag(:p,h(address.street) + '<br />' + city_state_zip)
  end
  
  def display_address_inline(address = nil)
    return unless address
    
    city_state_zip = h address.city
    city_state_zip += ', ' + h( address.state.abbreviation) unless address.state.nil?
    city_state_zip += ' ' + h( address.zip)
    content_tag(:p,h(address.street + ', ' + city_state_zip ))
  end
  
  def display_phone_number(p_number = nil)
    return unless p_number
    
    content_tag(:p,h(p_number.number))
    
  end
end