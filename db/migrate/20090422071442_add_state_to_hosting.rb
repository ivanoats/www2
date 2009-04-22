class AddStateToHosting < ActiveRecord::Migration
  def self.up
    add_column :hostings, :state, :string
    rename_column :hostings, :charge_peroid, :charge_period
  end

  def self.down
    rename_column :hostings, :charge_period, :charge_peroid
    remove_column :hostings, :state
  end
end
