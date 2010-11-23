require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Purchase do
  
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    @purchase = Purchase.create!(@valid_attributes)
  end
  
  it 'should create a hosting when redeemed as a package' do
    @purchase = Purchase.make(:product => Product.make(:kind => 'package'), :order => Order.make(:account => Account.make()), :children => [Purchase.make(:product => Product.make(:kind => 'domain'), :data => {:domain => 'www.panda.com'})])
    @hosting = @purchase.redeem
    assert_equal @hosting.valid?, true
    @hosting.stubs('create_cpanel_account').returns(true)
    assert_equal @hosting.state, 'ordered'    
  end
  
  it 'should create a domain when redeemed as a domain' do
    @purchase = Purchase.make(:product => Product.make(:kind => 'domain'), :order => Order.make(:account => Account.make()), :data => {:domain => 'www.panda.com'})
  end

  it 'should create an addon when redeemed as an addon' do
    @purchase = Purchase.make(:product => Product.make(:kind => 'addon'), :order => Order.make(:account => Account.make))
  end
    
end
