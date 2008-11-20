class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end
    
    create_table :taggings do |t|
      t.integer :tag_id, :taggable_id
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.string :taggable_type
      t.datetime :created_at
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
  end
  
  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
