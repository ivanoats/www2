class AddStatusToAddOns < ActiveRecord::Migration
  def self.up
    add_column :add_ons, :state, :string
  end

  def self.down
    remove_column :add_ons, :state
  end
end
