class CreateCartItems < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.integer :product_id
      t.integer :cart_id
      t.text :description
      t.float :unit_price
      t.integer :quantity
      t.string :quantity_unit

      t.timestamps
    end
  end

  def self.down
    drop_table :cart_items
  end
end
