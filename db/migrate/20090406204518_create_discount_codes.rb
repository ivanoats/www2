class CreateDiscountCodes < ActiveRecord::Migration
  def self.up
    create_table :discount_codes do |t|
      t.string :name
      t.integer :percent_off
      t.string :status
      t.datetime :expiration_date

      t.timestamps
    end
  end

  def self.down
    drop_table :discount_codes
  end
end
