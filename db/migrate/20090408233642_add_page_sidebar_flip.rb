class AddPageSidebarFlip < ActiveRecord::Migration
  def self.up
    add_column :pages, :flip_sidebar, :boolean
  end

  def self.down
    remove_column :pages, :flip_sidebar
  end
end
