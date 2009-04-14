class CreatePaymentProfiles < ActiveRecord::Migration
  def self.up
    create_table :payment_profiles do |t|
      t.column :account_id, :integer
      t.column :customer_payment_profile_id, :string
      t.column :active, :boolean
      t.column :default, :boolean
      t.timestamps
    end
    add_column :accounts, :customer_profile_id, :string
  end

  def self.down
    remove_column :accounts, :customer_profile_id
    drop_table :payment_profiles
  end
end
