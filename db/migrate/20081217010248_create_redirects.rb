class CreateRedirects < ActiveRecord::Migration
  def self.up
    create_table :redirects do |t|
      t.string :slug
      t.string :url
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :redirects
  end
end
