class CreateWhmappackages < ActiveRecord::Migration
  def self.up
    create_table :whmappackages do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :whmappackages
  end
end
