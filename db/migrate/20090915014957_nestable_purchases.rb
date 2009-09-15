class NestablePurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :parent_id, :integer
  end

  def self.down
    remove_column :purchases, :parent_id
  end
end
