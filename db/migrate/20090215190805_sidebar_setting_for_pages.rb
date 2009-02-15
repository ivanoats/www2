class SidebarSettingForPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :hide_sidebar, :boolean
  end

  def self.down
    remove_column :pages, :hide_sidebar
  end
end
