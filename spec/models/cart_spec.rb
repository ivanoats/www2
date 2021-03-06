require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cart do
  before(:each) do
    @valid_attributes = {
      :referrer_id => 1
    }

    @valid_product_attributes = {
      :name            => "Basic Web Hosting",
      :description     => "1,000MB Storage, 10,000MB Bandwidth, Unlimited Emails, Unlimited Addons, Fantastico",
      :cost            => 10.00,
      :recurring_month => 1,
      :status          => "enabled",
      :kind            => "package"
    }
  end

  it "should create a new instance given valid attributes" do
    Cart.create!(@valid_attributes)
  end

  it "should have many cart items" do
    association_results = {
      :macro      => :has_many,
      :class_name => "CartItem"
    }
    Cart.reflect_on_association(:cart_items).to_hash.should == association_results
  end

  it "should only allow referrer_id as an integer or nil" do
    lambda { Cart.create!(@valid_attributes.merge(:referrer_id => 1)) }.should_not raise_error
    lambda { Cart.create!(@valid_attributes.merge(:referrer_id => 0.99)) }.should raise_error
  end

  it "should allow referrer_id to be greater than 0" do
    lambda { Cart.create!(@valid_attributes.merge(:referrer_id => 0)) }.should raise_error
  end

  it "should allow referrer_id to be nil" do
    lambda { Cart.create!(@valid_attributes.merge(:referrer_id => '')) }.should_not raise_error
    lambda { Cart.create!(@valid_attributes.merge(:referrer_id => nil)) }.should_not raise_error
  end

  it "should add a Product to itself as a CartItem" do
    cart    = Cart.create!(@valid_attributes)
    product = Product.create!(@valid_product_attributes)

    cart_item = cart.add(product,product.name)
    cart_item.should == cart.cart_items.first
    cart_item.product_id.should == product.id
    cart_item.cart_id.should == cart.id
    cart_item.name.should == product.name
    cart_item.description.should == product.description
    cart_item.unit_price.should == product.cost
    cart_item.quantity.should == 1
    cart_item.quantity_unit.should == nil
  end

  it "should add a Product to itself as a CartItem with quantity" do
    cart     = Cart.create!(@valid_attributes)
    product  = Product.create!(@valid_product_attributes)
    quantity = 94

    cart_item = cart.add(product, product.name, {}, nil ,quantity)
    cart_item.should == cart.cart_items.first
    cart_item.product_id.should == product.id
    cart_item.cart_id.should == cart.id
    cart_item.name.should == product.name
    cart_item.description.should == product.description
    cart_item.unit_price.should == product.cost
    cart_item.quantity.should == quantity
    cart_item.quantity_unit.should == nil
  end

  it "should add a Product to itself as a CartItem with quantity and quantity unit" do
    cart          = Cart.create!(@valid_attributes)
    product       = Product.create!(@valid_product_attributes)
    quantity      = 12
    quantity_unit = "months"

    cart_item = cart.add(product, product.name, {}, nil, quantity, quantity_unit)
    cart_item.should == cart.cart_items.first
    cart_item.product_id.should == product.id
    cart_item.cart_id.should == cart.id
    cart_item.name.should == product.name
    cart_item.description.should == product.description
    cart_item.unit_price.should == product.cost
    cart_item.quantity.should == quantity
    cart_item.quantity_unit.should == quantity_unit
  end

  it "should remove a CartItem given it's id" do
    cart      = Cart.create!(@valid_attributes)
    product   = Product.create!(@valid_product_attributes)
    cart_item = cart.add(product, product.name)
    cart.save

    cart.cart_items.size.should == 1
    returned_cart_item = cart.remove(cart_item.id)
    cart.cart_items.size.should == 0
    returned_cart_item.should be_frozen
  end

  it "should change the quantity for a CartItem" do
    cart      = Cart.create!(@valid_attributes)
    product   = Product.create!(@valid_product_attributes)
    cart_item = cart.add(product, product.name)
    cart.save
    expected_quantity = 45

    changed_cart_item = cart.change_quantity(cart_item.id, expected_quantity)
    changed_cart_item.should == cart.cart_items.first
    changed_cart_item.quantity.should == expected_quantity
  end

  it "should remove a CartItem when changing its quantity to 0" do
    cart      = Cart.create!(@valid_attributes)
    product   = Product.create!(@valid_product_attributes)
    cart_item = cart.add(product, product.name)
    cart.save

    changed_cart_item = cart.change_quantity(cart_item.id, 0)
    changed_cart_item.should be_frozen
    cart.cart_items.find_by_id(cart_item.id).should be_nil
  end
  
  it "should calculate total price for a cart with items in it" do
    cart      = Cart.create!(@valid_attributes)
    product   = Product.create!(@valid_product_attributes)  # 10.00
    product2  = Product.create!(@valid_product_attributes.merge({:cost => 33}))
    cart_item = cart.add(product, product.name)
    cart_item2 = cart.add(product2, 3) # 3 times 33 = 99
    cart.save
    
    expected = cart.cart_items.inject(0) do |total,cart_item|
      total += cart_item.unit_price * cart_item.quantity
    end
    
    cart.total_price.should == expected
  end
end
