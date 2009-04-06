class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :organization
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country
      t.string :phone
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
