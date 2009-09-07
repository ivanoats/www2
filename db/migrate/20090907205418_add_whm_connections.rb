class AddWhmConnections < ActiveRecord::Migration
  def self.up
    add_column :accounts, :whmapuser_id, :integer
    add_column :hostings, :whmaphostingorder_id, :integer
  end

  def self.down
    remove_column :hostings, :whmaphostingorder_id
    remove_column :accounts, :whmapuser_id
  end
end
