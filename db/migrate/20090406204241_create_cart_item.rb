class CreateCartItem < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.integer :product_id
      t.integer :cart_id
      t.text :name
      t.text :description
      t.integer :unit_price_in_cents
      t.integer :quantity
      t.string :quantity_unit

      t.timestamps
    end
  end

  def self.down
    drop_table :cart_items
  end
end
