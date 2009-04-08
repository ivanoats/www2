require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProductsController do

  def mock_product(stubs={})
    @mock_product ||= mock_model(Product, stubs)
  end
  
  describe "GET index" do

    it "exposes all products as @products" do
      Product.should_receive(:find).with(:all).and_return([mock_product])
      get :index
      assigns[:products].should == [mock_product]
    end

    describe "with mime type of xml" do
  
      it "renders all products as xml" do
        Product.should_receive(:find).with(:all).and_return(products = mock("Array of Products"))
        products.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested product as @product" do
      Product.should_receive(:find).with("37").and_return(mock_product)
      get :show, :id => "37"
      assigns[:product].should equal(mock_product)
    end
    
    describe "with mime type of xml" do

      it "renders the requested product as xml" do
        Product.should_receive(:find).with("37").and_return(mock_product)
        mock_product.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new product as @product" do
      Product.should_receive(:new).and_return(mock_product)
      get :new
      assigns[:product].should equal(mock_product)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested product as @product" do
      Product.should_receive(:find).with("37").and_return(mock_product)
      get :edit, :id => "37"
      assigns[:product].should equal(mock_product)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created product as @product" do
        Product.should_receive(:new).with({'these' => 'params'}).and_return(mock_product(:save => true))
        post :create, :product => {:these => 'params'}
        assigns(:product).should equal(mock_product)
      end

      it "redirects to the created product" do
        Product.stub!(:new).and_return(mock_product(:save => true))
        post :create, :product => {}
        response.should redirect_to(product_url(mock_product))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved product as @product" do
        Product.stub!(:new).with({'these' => 'params'}).and_return(mock_product(:save => false))
        post :create, :product => {:these => 'params'}
        assigns(:product).should equal(mock_product)
      end

      it "re-renders the 'new' template" do
        Product.stub!(:new).and_return(mock_product(:save => false))
        post :create, :product => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested product" do
        Product.should_receive(:find).with("37").and_return(mock_product)
        mock_product.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product => {:these => 'params'}
      end

      it "exposes the requested product as @product" do
        Product.stub!(:find).and_return(mock_product(:update_attributes => true))
        put :update, :id => "1"
        assigns(:product).should equal(mock_product)
      end

      it "redirects to the product" do
        Product.stub!(:find).and_return(mock_product(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(product_url(mock_product))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested product" do
        Product.should_receive(:find).with("37").and_return(mock_product)
        mock_product.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product => {:these => 'params'}
      end

      it "exposes the product as @product" do
        Product.stub!(:find).and_return(mock_product(:update_attributes => false))
        put :update, :id => "1"
        assigns(:product).should equal(mock_product)
      end

      it "re-renders the 'edit' template" do
        Product.stub!(:find).and_return(mock_product(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested product" do
      Product.should_receive(:find).with("37").and_return(mock_product)
      mock_product.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the products list" do
      Product.stub!(:find).and_return(mock_product(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(products_url)
    end

  end

end
