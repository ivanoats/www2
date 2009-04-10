class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :account_id
      t.integer :order_id
      t.integer :amount
      t.string :state
      t.timestamps
    end
    add_column :accounts, :balance, :integer
  end

  def self.down
    remove_column :accounts, :balance
    drop_table :payments
  end
end
