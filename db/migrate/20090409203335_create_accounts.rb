class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      
      t.string :first_name
      t.string :last_name
      t.string :organization
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country
      t.string :phone
      
      t.timestamps
    end
    
    create_table :accounts_users, :id => false do |t|
      t.integer :account_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :accounts_users
    drop_table :accounts
  end
end
