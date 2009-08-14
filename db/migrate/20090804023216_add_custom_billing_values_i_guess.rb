class AddCustomBillingValuesIGuess < ActiveRecord::Migration
  def self.up
    add_column :hostings, :custom_cost, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :hostings, :custom_cost
  end
end
