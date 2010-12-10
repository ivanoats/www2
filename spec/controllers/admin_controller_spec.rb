require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminController do
  before :each do
    @user = mock('User', {:has_role? => true})
    @controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', {}, {:user_id => 1}
      response.should have_been_success
    end
  end
  
  it 'should post provision' do
    @server = Server.new
    Server.expects(:find).with('1').returns(@server)

    @hostings = [Hosting.new,Hosting.new]
    @hostings.each { |hosting| hosting.expects(:activate!).returns(true); hosting.expects(:initialize_next_charge).returns(true)}
    Hosting.expects(:find).with([1,2]).returns(@hostings)

    post 'provision', {:server => 1, :hosting => {1 => true, 2 => true}}
    response.should have_been_redirect
    response.should redirect_to(admin_url)
    flash[:error].should == nil
  end
  
  it 'should fail to provision' do
    post 'provision', {:server => 1, :hosting => {1 => true, 2 => true}}
    flash[:error].should match /Couldn't find/
  end
  
  it 'should post approve' do
    @domains = [Domain.new,Domain.new]
    @domains.each { |domain| domain.expects(:activate!).returns(true)}
    Domain.expects(:find).with([1,2]).returns(@domains)
    post 'approve', {:domain => {1 => true, 2 => true}}
    response.should have_been_redirect
    response.should redirect_to(admin_url)
    flash[:error].should == nil
  end
  
  it 'should fail to approve' do
    post 'approve', {:domain => {1 => true, 2 => true}}
    flash[:error].should =~ /Couldn't find/    
  end

  it 'should post complete' do
    @addons = [AddOn.new,AddOn.new]
    @addons.each { |addon| addon.expects(:completed!).returns(true); addon.expects(:product).returns(Product.new(:recurring_month => 0))}
    AddOn.expects(:find).with([1,2]).returns(@addons)
    
    post 'complete', {:add_on => {1 => true, 2 => true}}
    response.should have_been_redirect
    response.should redirect_to(admin_url)
    flash[:error].should == nil
  end
  
  it 'should fail to complete' do
    post 'complete', {:add_on => {1 => true, 2 => true}}
    flash[:error].should =~ /Couldn't find/    
  end
  
  
end
