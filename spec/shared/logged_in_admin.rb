describe "an admin user is signed in", :shared => true do
  before( :each ) do
     controller.stub!( :login_required )  #mock user is logged in
     controller.current_user = mock_model(User, :has_role? => true )  #mock user is admin 
   end
end
