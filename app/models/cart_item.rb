class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  
  acts_as_tree
  
  has_many :products, :through => :children
  
  serialize :data, Hash

  validates_presence_of :name, :description
  validates_numericality_of :unit_price, :greater_than_or_equal_to => 0
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0  

  def domain
    self.children.find(:first, :include => :product, :conditions => ["products.kind = ?",'domain'])
  end
end
