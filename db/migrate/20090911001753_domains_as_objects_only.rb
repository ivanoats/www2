class DomainsAsObjectsOnly < ActiveRecord::Migration
  def self.up
    remove_column :hostings, :domain
  end

  def self.down
    add_column :hostings, :domain, :string
  end
end
