class HostingsConnectedToServers < ActiveRecord::Migration
  def self.up
    add_column :hostings, :server_id, :integer
    add_column :hostings, :cpanel_user, :string
  end

  def self.down
    remove_column :hostings, :cpanel_user
    remove_column :hostings, :server_id
  end
end
