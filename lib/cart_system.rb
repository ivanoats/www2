module CartSystem
  protected
  
  def load_cart
    @cart = Cart.find_by_id(session[:cart_id]) if session[:cart_id]
    unless @cart
      @cart = Cart.create!
      session[:cart_id] = @cart.id
    end
  end
end