class AddDataToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :data, :text
    remove_column :products, :data
  end

  def self.down
    add_column :products, :data, :text
    remove_column :purchases, :data
  end
end
