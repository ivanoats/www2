describe "an admin user is signed in", :shared => true do
  before( :each ) do
     controller.stubs( :login_required )  #mock user is logged in
     controller.stubs(:current_user).returns(mock_model(User, :has_role? => true ))
   end
end
