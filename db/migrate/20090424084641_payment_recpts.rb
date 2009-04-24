class PaymentRecpts < ActiveRecord::Migration
  def self.up
    add_column :payments, :receipt, :text
  end

  def self.down
    remove_column :payments, :receipt
  end
end
