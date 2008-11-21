class ArticleCustomizablePermalink < ActiveRecord::Migration
  def self.up
    add_column :articles, :link, :string
  end

  def self.down
    remove_column :articles, :link
  end
end
