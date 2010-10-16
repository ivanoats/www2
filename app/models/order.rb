# a group of purchased products
class Order < ActiveRecord::Base
  include AASM
  include TokenGenerator
  
  belongs_to :account
  
  has_many :purchases
  has_many :products, :through => :purchases
  has_one :payment, :as => :payable
  
  aasm_column :state
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :paid, :enter => :order_was_paid
  aasm_state :cancelled
  
  aasm_event :paid do
    transitions :to => :paid, :from => :pending
  end
  
  attr_protected :token
  before_validation_on_create :set_token
  
  validates_presence_of :token
  
  # @param [Cart] cart the shopping cart
  # @return [Order] an new order object from the shopping cart
  def self.from_cart(cart)
    order = Order.new
    cart.cart_items.find(:all, :conditions => "parent_id IS NULL").each do |item|
      unless item.product.nil?
        purchase = Purchase.new(:product => item.product, :data => item.data)
        order.purchases << purchase
        item.children.each do |child|
          purchase.children << Purchase.new(:product => child.product, :data => child.data, :order => order) unless child.product.nil?
        end
      end
    end
    order
  end

  # @return [Integer] sum total of purchases
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
  
  
end