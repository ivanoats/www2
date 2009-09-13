class NestedCartItems < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :parent_id, :integer
  end

  def self.down
    remove_column :cart_items, :parent_id
  end
end
