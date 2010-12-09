# Test model controller methods.  Because these are overrideable, you can add only the ones you need

# it_should_behave_like "model controller index"
# it_should_behave_like "model controller create"
# it_should_behave_like "model controller update"
# it_should_behave_like "model controller show"
# it_should_behave_like "model controller edit"
# it_should_behave_like "model controller destroy"


describe "model controller index", :shared => true do
  it 'should get index' do
    get 'index'
    response.should have_been_success
  end
end

describe "model controller create", :shared => true do

  it 'should post create' do
    @obj = @controller.send(:scoper).new
    @obj.stubs(:valid? => true, :save => true, :id => 'test', :to_param => 'test')
    @controller.instance_variable_set('@' + @controller.send(:cname),@obj)
    @controller.instance_variable_set('@obj',@obj)
    @controller.stubs(:build_object)
    
    post 'create'
    
    response.should have_been_redirect
    response.should redirect_to(@controller.send :modified_redirect_url)
  end
end

describe "model controller new", :shared => true do

  it 'should get new' do
    @obj = @controller.send(:scoper).new
    @obj.stubs(:valid? => true, :save => true, :id => 'test', :to_param => 'test')
    @controller.instance_variable_set('@' + @controller.send(:cname),@obj)
    @controller.instance_variable_set('@obj',@obj)
    @controller.stubs(:build_object)
    
    get 'new'
    response.should have_been_success
  end
end


describe "model controller update", :shared => true do

  it 'should post update' do
    @obj = @controller.send(:scoper).new
    @obj.stubs(:valid? => true, :save => true, :id => 'test', :to_param => 'test')
    @controller.instance_variable_set('@' + @controller.send(:cname),@obj)
    @controller.instance_variable_set('@obj',@obj)
    @controller.stubs(:load_object)
    
    post 'update'
    response.should have_been_redirect
    response.should redirect_to(@controller.send :modified_redirect_url)
  end
end

describe "model controller show", :shared => true do

  it 'should get show' do
    @obj = @controller.send(:scoper).new
    @obj.stubs(:valid? => true, :save => true, :id => 'test', :to_param => 'test')
    @controller.instance_variable_set('@' + @controller.send(:cname),@obj)
    @controller.instance_variable_set('@obj',@obj)
    @controller.stubs(:load_object)
    
    get 'show'
    response.should have_been_success
  end
end

describe "model controller edit", :shared => true do
  
  it 'should get edit' do
    @obj = @controller.send(:scoper).new
    @obj.stubs(:valid? => true, :save => true, :id => 'test', :to_param => 'test')
    @controller.instance_variable_set('@' + @controller.send(:cname),@obj)
    @controller.instance_variable_set('@obj',@obj)
    @controller.stubs(:load_object)
    
    get 'edit'
    response.should have_been_success
  end
end

describe "model controller destroy", :shared => true do
  
  it 'should post destroy' do
    @obj = @controller.send(:scoper).new
    @obj.stubs(:valid? => true, :save => true, :id => 'test', :to_param => 'test')
    @controller.instance_variable_set('@' + @controller.send(:cname),@obj)
    @controller.instance_variable_set('@obj',@obj)
    @controller.stubs(:load_object)
    
    post 'destroy'
    response.should have_been_redirect
    response.should redirect_to(@controller.send :redirect_url)
  end
  
  
end
