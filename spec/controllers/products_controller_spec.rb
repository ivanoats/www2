require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProductsController do

  def mock_product(stubs={})
    @mock_product ||= mock_model(Product, stubs)
  end
  
  describe "GET index" do

    it_should_behave_like "an admin user is signed in"

    it "exposes all products as @products" do
      Product.expects(:find).with(:all).returns([mock_product])
      get :index
      assigns[:products].should == [mock_product]
    end


  end

  describe "GET show" do

    it_should_behave_like "an admin user is signed in"

    it "exposes the requested product as @product" do
      Product.expects(:find).with("37").returns(mock_product)
      get :show, :id => "37"
      assigns[:product].should equal(mock_product)
    end
    
    
  end

  describe "GET new" do

    it_should_behave_like "an admin user is signed in"

    it "exposes a new product as @product" do
      Product.expects(:new).returns(mock_product)
      get :new
      assigns[:product].should equal(mock_product)
    end

  end

  describe "GET edit" do
    
    it_should_behave_like "an admin user is signed in"
  
    it "exposes the requested product as @product" do
      Product.expects(:find).with("37").returns(mock_product)
      get :edit, :id => "37"
      assigns[:product].should equal(mock_product)
    end

  end

  describe "POST create" do

    it_should_behave_like "an admin user is signed in"

    describe "with valid params" do
      
      it "exposes a newly created product as @product" do
        Product.expects(:new).with({'these' => 'params'}).returns(mock_product(:save => true))
        post :create, :product => {:these => 'params'}
        assigns(:product).should equal(mock_product)
      end

      it "redirects to the created product" do
        Product.stubs(:new).returns(mock_product(:save => true))
        post :create, :product => {}
        response.should redirect_to(product_url(mock_product))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved product as @product" do
        Product.stubs(:new).with({'these' => 'params'}).returns(mock_product(:save => false))
        post :create, :product => {:these => 'params'}
        assigns(:product).should equal(mock_product)
      end

      it "re-renders the 'new' template" do
        Product.stubs(:new).returns(mock_product(:save => false))
        post :create, :product => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    it_should_behave_like "an admin user is signed in"

    describe "with valid params" do

      it "updates the requested product" do
        Product.expects(:find).with("37").returns(mock_product)
        mock_product.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product => {:these => 'params'}
      end

      it "exposes the requested product as @product" do
        Product.stubs(:find).returns(mock_product(:update_attributes => true))
        put :update, :id => "1"
        assigns(:product).should equal(mock_product)
      end

      it "redirects to the product" do
        Product.stubs(:find).returns(mock_product(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(product_url(mock_product))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested product" do
        Product.expects(:find).with("37").returns(mock_product)
        mock_product.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product => {:these => 'params'}
      end

      it "exposes the product as @product" do
        Product.stubs(:find).returns(mock_product(:update_attributes => false))
        put :update, :id => "1"
        assigns(:product).should equal(mock_product)
      end

      it "re-renders the 'edit' template" do
        Product.stubs(:find).returns(mock_product(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it_should_behave_like "an admin user is signed in"

    it "destroys the requested product" do
      Product.expects(:find).with("37").returns(mock_product)
      mock_product.expects(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the products list" do
      Product.stubs(:find).returns(mock_product(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(products_url)
    end

  end

end
