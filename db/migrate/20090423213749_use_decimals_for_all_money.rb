class UseDecimalsForAllMoney < ActiveRecord::Migration
  def self.up
    change_column :accounts, :balance, :decimal, :precision => 10, :scale => 2, :default => 0.0
    remove_column :cart_items, :unit_price_in_cents
    add_column :cart_items, :unit_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
    remove_column :charges, :amount_in_cents
    add_column :charges, :amount, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :payments, :amount, :decimal, :precision => 10, :scale => 2, :default => 0.0
    remove_column :products, :cost_in_cents
    add_column :products, :cost, :decimal, :precision => 10, :scale => 2, :default => 0.0
    
    drop_if_exists? 'tracker_recurring_payment_profiles'
    drop_if_exists? 'tracker_transactions'
    drop_if_exists? 'subscription_profiles'
    drop_if_exists? 'subscriptions'
    drop_if_exists? 'customers'
  end

  def self.down
    remove_column :products, :cost
    add_column :products, :cost_in_cents, :integer
    change_column :payments, :amount, :integer
    remove_column :charges, :amount
    add_column :charges, :amount_in_cents, :integer
    remove_column :cart_items, :unit_price
    add_column :cart_items, :unit_price_in_cents, :integer
    change_column :accounts, :balance, :integer
  end
  
end

def drop_if_exists?(table_name)
  drop_table(table_name) if ActiveRecord::Base.connection.tables.include?(table_name)
end
