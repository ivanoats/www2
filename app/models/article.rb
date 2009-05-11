class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many   :photos
  
  acts_as_commentable
  acts_as_taggable
  
  before_save :update_published_at 
  
  validates_presence_of :title
  validates_uniqueness_of :title, :on => :create, :message => "must be unique" 
  validates_presence_of :synopsis 
  validates_presence_of :body 
  validates_length_of :title, :maximum => 255 
  validates_length_of :synopsis, :maximum => 1000 
  validates_length_of :body, :maximum => 20000 
  
  validates_uniqueness_of :permalink
  
  def before_save
    self.permalink = self.title if self.permalink.blank?
    self.permalink.gsub!('_','-')
    self.permalink = PermalinkFu.escape(self.permalink)
  end
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
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
  
end
