module CartSystem
  protected
  
  def load_cart
    # create a cart unless one exists (for this session)
    # if there is a cart in the session, then find a cart by the cart id
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
    # if not, create a new cart
    else
      @cart = Cart.create!
      session[:cart_id] = @cart.id
    end # if session[:cart_id]
  end
end