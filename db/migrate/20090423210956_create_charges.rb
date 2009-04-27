class CreateCharges < ActiveRecord::Migration
  def self.up
    create_table :charges do |t|
      t.integer :account_id
      t.integer :amount_in_cents
      t.integer :chargable_id
      t.string  :chargable_type
      t.string  :description
      t.timestamps
    end
  end

  def self.down
    drop_table :charges
  end
end
