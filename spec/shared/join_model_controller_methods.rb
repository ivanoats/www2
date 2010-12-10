

describe "join model controller create", :shared => true do
  it 'should post create' do

    @controller.stubs(:modified_redirect_url).returns('/url')
    @object = @controller.send(:first_class).new
    @controller.send(:first_class).expects(:find).with('1').returns(@object)    
    @params = {"#{@controller.send(:first_class_name).singularize}_id" => 1, "#{@controller.send(:last_class_name).singularize}_id" => 2}  
    
    #could test for << 
    
    post 'create', @params
    
    response.should have_been_redirect
    response.should redirect_to('http://test.host/url')
  end
end

describe "join model controller destroy", :shared => true do
  it 'should post destroy' do
    
    @controller.stubs(:modified_redirect_url).returns('/url')
    @object = @controller.send(:first_class).new
    @controller.send(:first_class).expects(:find).with('1').returns(@object)    
    @params = {"#{@controller.send(:first_class_name).singularize}_id" => 1, "#{@controller.send(:last_class_name).singularize}_id" => 2}  
    
    #could test for delete
    
    post 'destroy', @params
    response.should have_been_success
  end
end
