class EnhancePayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :transaction_id, :integer
    add_column :accounts, :zip, :string
    add_column :accounts, :email, :string
    remove_column :purchases, :product_id
    add_column :purchases, :purchasable_id, :integer
    add_column :purchases, :purchasable_type, :integer
  end

  def self.down
    remove_column :purchases, :purchasable_type
    remove_column :purchases, :purchasable_id
    add_column :purchases, :product_id, :integer
    remove_column :accounts, :email
    remove_column :accounts, :zip
    remove_column :payments, :transaction_id
  end
end
