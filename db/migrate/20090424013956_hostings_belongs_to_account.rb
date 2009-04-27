class HostingsBelongsToAccount < ActiveRecord::Migration
  def self.up
    add_column :hostings, :account_id, :integer
  end

  def self.down
    remove_column :hostings, :account_id
  end
end
