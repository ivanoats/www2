class Order < ActiveRecord::Base
  belongs_to :account
  
  has_many :purchases
  has_many :products, :through => :purchases
  
  before_create :create_invoice_number
  
  aasm_column :state
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :paid
  aasm_state :cancelled
  
  aasm_event :paid do
    transitions :to => :paid, :from => :pending
  end
  
    def self.from_cart(cart)
      order = Order.new
      cart.cart_items.each do |item|
        if item.product
          values[:quantity].times do 
            order.purchases << Purchase.new(:product => item.product)
          end
        end
      end
      order.save

      order
    end

    def paypal?
      false
    end

    def total_charge
      self.products.to_a.sum(&:cost)
    end

    def total_charge_in_pennies
      (self.total_charge * 100).to_i
    end

  private

    def self.generate_invoice_number
      now = Time.now
      year_days_seconds_milliseconds = now.strftime('%Y%j-') + now.to_f.to_s.delete('.')

      year_days_seconds_milliseconds
    end

    def create_invoice_number
      self.invoice_number = Order.generate_invoice_number unless self.invoice_number
    end  
  
  
end
