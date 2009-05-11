class ConnectDomainsToAccount < ActiveRecord::Migration
  def self.up
    add_column :domains, :account_id, :integer
    add_column :domains, :product_id, :integer
  end

  def self.down
    remove_column :domains, :product_id
    remove_column :domains, :account_id
  end
end
