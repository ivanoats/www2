class AddCustomReocurring < ActiveRecord::Migration
  def self.up
    add_column :hostings, :custom_recurring_month, :integer
  end

  def self.down
    remove_column :hostings, :custom_recurring_month
  end
end
