class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.integer :order_id
      t.integer :product_id
      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
