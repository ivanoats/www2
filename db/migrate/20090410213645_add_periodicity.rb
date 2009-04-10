class AddPeriodicity < ActiveRecord::Migration
  def self.up
    add_column :accounts, :last_payment_on, :date
    add_column :accounts, :payment_period, :string
    add_column :hostings, :last_charge_on, :date
    add_column :hostings, :charge_peroid, :string
  end

  def self.down
    remove_column :hostings, :charge_period
    remove_column :hostings, :last_charge_on
    remove_column :accounts, :payment_period
    remove_column :accounts, :last_payment_on
  end
end
