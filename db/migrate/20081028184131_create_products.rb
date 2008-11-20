class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.integer :price_dollars
      t.integer :price_cents

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
