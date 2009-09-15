class Order < ActiveRecord::Base
  include AASM
  
  belongs_to :account
  
  has_many :purchases
  has_many :products, :through => :purchases
  has_one :payment, :as => :payable
  
  before_create :create_invoice_number
  
  aasm_column :state
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :paid, :enter => :order_was_paid
  aasm_state :cancelled
  
  aasm_event :paid do
    transitions :to => :paid, :from => :pending
  end
  
  def self.from_cart(cart)
    order = Order.new
    cart.cart_items.find(:all, :conditions => "parent_id IS NULL").each do |item|
      if item.product
        purchase = Purchase.new(:product => item.product, :data => item.data)
        order.purchases << purchase
        item.children.each do |child|
          purchase.children << Purchase.new(:product => child.product, :data => child.data, :order => order)
        end
      end
    end
    order
  end

  def total_charge
    self.purchases.collect { |purchase| purchase.product }.sum(&:cost)
  end

  def total_charge_in_cents
    (self.total_charge * 100).to_i
  end    

private

  def order_was_paid
    self.purchases.find(:all, :conditions => "parent_id IS NULL").each { |purchase| purchase.redeem }
  end
  
  def self.generate_invoice_number
    now = Time.now
    year_days_seconds_milliseconds = now.strftime('%Y%j-') + now.to_f.to_s.delete('.')

    year_days_seconds_milliseconds
  end

  def create_invoice_number
    self.invoice_number = Order.generate_invoice_number unless self.invoice_number
  end  

end
