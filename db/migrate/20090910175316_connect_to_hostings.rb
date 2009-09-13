class ConnectToHostings < ActiveRecord::Migration
  def self.up
    add_column :domains, :hosting_id, :integer
    add_column :add_ons, :hosting_id, :integer
  end

  def self.down
    remove_column :add_ons, :hosting_id
    remove_column :domains, :hosting_id
  end
end
