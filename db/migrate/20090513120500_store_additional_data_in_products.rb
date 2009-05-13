class StoreAdditionalDataInProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :data, :text
    add_column :cart_items, :data, :text
  end

  def self.down
    remove_column :cart_items, :data
    remove_column :products, :data
  end
end
