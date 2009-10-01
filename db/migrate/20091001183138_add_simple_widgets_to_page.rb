class AddSimpleWidgetsToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :widget1, :string
    add_column :pages, :widget2, :string
    add_column :pages, :widget3, :string
    add_column :pages, :widget4, :string
  end

  def self.down
    remove_column :pages, :widget4
    remove_column :pages, :widget3
    remove_column :pages, :widget2
    remove_column :pages, :widget1
  end
end
