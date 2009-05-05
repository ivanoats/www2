class AddPageNewLayout < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_teaser, :boolean
    add_column :pages, :teaser, :string
  end

  def self.down
    remove_column :pages, :teaser
    remove_column :pages, :show_teaser
  end
end
