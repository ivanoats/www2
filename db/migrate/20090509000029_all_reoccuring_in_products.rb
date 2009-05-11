class AllReoccuringInProducts < ActiveRecord::Migration
  def self.up
    remove_column :hostings, :charge_period
    rename_column :hostings, :last_charge_on, :next_charge_on
  end

  def self.down
    rename_column :hostings, :next_charge_on, :last_charge_on
    add_column :hostings, :charge_period, :string
  end
end
