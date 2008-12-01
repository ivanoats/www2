class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  
  acts_as_commentable
  acts_as_taggable
  #has_permalink :title
  
  before_save :update_published_at 
  
  validates_presence_of :title
  validates_uniqueness_of :title, :on => :create, :message => "must be unique" 
  validates_presence_of :synopsis 
  validates_presence_of :body 
  validates_length_of :title, :maximum => 255 
  validates_length_of :synopsis, :maximum => 1000 
  validates_length_of :body, :maximum => 20000 
  
  validates_uniqueness_of :permalink
  
  def before_validation
    self.permalink = self.title unless self.permalink_changed?
  end
  
  def permalink=(new_value)
    new_value = self.title if new_value.blank?
    write_attribute(:permalink,PermalinkFu.escape(new_value))
  end
  
  def self.per_page
    10
  end
  
  def self.search(search)
    if search
      find(:all, :conditions => ['(body LIKE ?) AND published = true',"%#{search}%" ])
    else
      find(:all)
    end
  end
  
  # updates the article published at time
  def update_published_at 
    self.published_at = Time.now if published == true 
  end
  
  
  #def to_param 
    #{}"#{id}-#{permalink}" 
   # permalink
  #end
end
