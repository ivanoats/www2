class NextChargeOnAddons < ActiveRecord::Migration
  def self.up
    add_column :add_ons, :next_charge_on, :date
    add_column :domains, :next_charge_on, :date
    
    remove_column :hostings, :custom_cost
    remove_column :hostings, :custom_recurring_month
  end

  def self.down
    add_column :hostings, :custom_recurring_month, :integer
    add_column :hostings, :custom_cost, :decimal,            :precision => 10, :scale => 2
    remove_column :add_ons, :next_charge_on
    remove_column :domains, :next_charge_on
  end
end
