class CreatePages < ActiveRecord::Migration
  def self.up 
    create_table :pages do |t| 
      t.string :title, :permalink 
      t.text :body
      t.belongs_to :user
      t.boolean :restricted # TODO make a groups system 
      t.timestamps
    end 
    Page.create(:title => "Sustainable Websites Home", 
                :permalink => "home", 
                :body => "stub for sustainable websites home page")
  end 
  def self.down 
    drop_table :pages 
  end
end
