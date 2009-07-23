class StatefulDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :state, :string
  end

  def self.down
    remove_column :domains, :state
  end
end
