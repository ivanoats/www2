class CorrectFunkyIds < ActiveRecord::Migration
  def self.up
    rename_column :articles, :user_id_id, :user_id
    rename_column :articles, :category_id_id, :category_id
  end

  def self.down
    rename_column :articles, :category_id, :category_id_id
    rename_column :articles, :user_id, :user_id_id
  end
end
