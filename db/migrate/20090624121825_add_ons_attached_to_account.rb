class AddOnsAttachedToAccount < ActiveRecord::Migration
  def self.up
    remove_column :add_ons, :hosting_id
    add_column :add_ons, :account_id, :integer
  end

  def self.down
    remove_column :add_ons, :account_id
    add_column :add_ons, :hosting_id, :integer
  end
end
