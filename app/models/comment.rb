class Comment < ActiveRecord::Base
  
# mysql -Dwww2_sw -e "describe comments;"
# Field Type  Null  Key Default Extra
# id  int(11) NO  PRI NULL  auto_increment
# title varchar(255)  YES     
# comment text  YES   NULL  
# created_at  datetime  YES   NULL  
# updated_at  datetime  YES   NULL  
# user_id int(11) NO  MUL 0 
# web_site  varchar(255)  YES   NULL  
# email varchar(255)  YES   NULL  
# name  varchar(255)  YES   NULL  
# commentable_id  int(11) YES   NULL  
# commentable_type  varchar(255)  YES   NULL  

# describe comments  
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :email, :on => :create, :message => "can't be blank"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "email is invalid"
  validates_presence_of :comment, :on => :create, :message => "can't be blank"
  validates_presence_of :commentable, :on => :create, :message => "you have to comment on something!"
  
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_comments_by_user(userid)
    find(:all,
      :conditions => ["user_id = ?", userid],
      :order => "created_at DESC"
    )
  end
  
  # Helper class method to look up all comments for 
  # commentable class name and commentable id. 
  # commented out because I couldn't imagine what I could use it for
  #
  # def self.find_comments_for_commentable(commentable_str, commentable_id)
  #     find(:all,
  #       :conditions => ["commentable_type = ? and commentable_id = ?", commentable_str, commentable_id],
  #       :order => "created_at DESC"
  #     )
  #   end

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  # commented out because I couldn't imagine what I could use it for
  #
  # def self.find_commentable(commentable_str, commentable_id)
  #   commentable_str.constantize.find(commentable_id)
  # end
end