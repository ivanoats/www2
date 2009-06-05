class AddHostingPassword < ActiveRecord::Migration
  def self.up
    rename_column :hostings, :cpanel_user, :username
    add_column :hostings, :password, :string
    add_column :hostings, :domain, :string
  end

  def self.down
    remove_column :hostings, :domain
    remove_column :hostings, :password
    rename_column :hostings, :username, :cpanel_user
  end
end
