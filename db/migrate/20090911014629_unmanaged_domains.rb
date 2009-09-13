class UnmanagedDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :purchased, :boolean
  end

  def self.down
    remove_column :domains, :purchased
  end
end
