class TokenizeOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :token, :string, :limit => 40
    remove_column :orders, :invoice_number
    
    Order.all.each { |o| o.set_token; o.save! }
  
  end

  def self.down
    add_column :orders, :invoice_number, :string
    remove_column :orders, :token
  end
end
