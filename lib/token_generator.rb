module TokenGenerator
  def generate_token(size = 12, &validity)

    begin
      token = ActiveSupport::SecureRandom.hex(64).first(size)
    end while !validity.call(token) if block_given?
 
    token
  end
 
  def set_token
    self.token = generate_token { |token| self.class.find_by_token(token).nil? }
  end
end