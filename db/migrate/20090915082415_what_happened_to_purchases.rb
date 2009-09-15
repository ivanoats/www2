class WhatHappenedToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :product_id, :integer
    remove_column :purchases, :purchasable_id
    remove_column :purchases, :purchasable_type
  end

  def self.down
    add_column :purchases, :purchasable_type, :integer
    add_column :purchases, :purchasable_id, :integer
    remove_column :purchases, :product_id
  end
end
