class CreateAddOns < ActiveRecord::Migration
  def self.up
    create_table :add_ons do |t|
      t.integer :hosting_id
      t.integer :product_id
      t.timestamps
    end
  end

  def self.down
    drop_table :add_ons
  end
end
