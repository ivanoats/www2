class CreateProducts < ActiveRecord::Migration
  def self.up
    # drop_table :products if it exists with the force option
    create_table :products, :force => true do |t|
      t.string :name
      t.text :description
      t.integer :cost
      t.integer :recurring_month
      t.string :status
      t.string :kind

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
