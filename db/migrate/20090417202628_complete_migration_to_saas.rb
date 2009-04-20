class CompleteMigrationToSaas < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :customer_profile_id, :billing_id
    add_column :accounts, :card_number, :string
    add_column :accounts, :card_expiration, :string
    add_column :accounts, :billing_address_id, :integer
    add_column :accounts, :address_id, :integer
    
    remove_column :accounts, :address_1
    remove_column :accounts, :address_2
    remove_column :accounts, :city
    remove_column :accounts, :zip
    remove_column :accounts, :country
  end

  def self.down
    add_column :accounts, :country, :string
    add_column :accounts, :zip, :string
    add_column :accounts, :city, :string
    add_column :accounts, :address_2, :string
    add_column :accounts, :address_1, :string
    remove_column :accounts, :address_id
    remove_column :accounts, :billing_address_id
    remove_column :accounts, :card_expiration
    remove_column :accounts, :card_number
    rename_column :accounts, :billing_id, :customer_profile_id
  end
end
