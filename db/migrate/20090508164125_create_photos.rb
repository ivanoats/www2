class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.references :article
      t.timestamps
    end
    add_index :photos, :article_id
  end

  def self.down
    drop_table :photos
  end
end
