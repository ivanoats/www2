class AddMissingUserProperties < ActiveRecord::Migration
  def self.up
    add_column :users, :enabled, :boolean, :default => true, :null => false
    add_column :users, :profile, :text
    add_column :users, :last_login_at, :datetime
  end

  def self.down
    remove_column :users, :last_login_at
    remove_column :users, :profile
    remove_column :users, :enabled
  end
end
