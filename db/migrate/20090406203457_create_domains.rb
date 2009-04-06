class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name
      t.boolean :monitor_resolve
      t.boolean :resolved
      t.datetime :expires_on

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
