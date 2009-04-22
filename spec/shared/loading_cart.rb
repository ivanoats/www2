describe "load an existing cart", :shared => true do
  expected_cart = Cart.create!
  session[:cart_id] = expected_cart.id
  
  # pass this in?
  get 'choose_domain'
  
  session[:cart_id].should == expected_cart.id
  assigns[:cart].id.should == expected_cart.id
end
