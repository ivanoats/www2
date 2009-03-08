class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string :name
      t.string :ip_address
      t.string :vendor
      t.string :location
      t.string :primary_ns
      t.string :primary_ns_ip
      t.string :secondary_ns
      t.string :secondary_ns_ip
      t.integer :max_accounts
      t.string :whm_user
      t.string :whm_pass
      t.text :whm_key

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
