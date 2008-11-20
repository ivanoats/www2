class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.belongs_to :user_id, :category_id
      t.string :title, :permalink, :cached_tag_list
      t.text :synopsis, :limit => 1000 
      t.text :body, :limit => 20000 
      t.boolean :published, :default => false 
      t.column :published_at, :datetime 
      t.boolean :comments_enabled
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
