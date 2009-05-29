class DataBackOnProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :data, :text
  end

  def self.down
    remove_column :products, :data
  end
end
