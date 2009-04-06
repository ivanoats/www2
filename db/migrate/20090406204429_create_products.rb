class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :cost
      t.integer :recurring_period
      t.string :status
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
