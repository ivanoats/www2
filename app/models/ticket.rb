class Ticket < ActiveRecord::Base
  validates_presence_of :email, :on => :create, :message => "can't be blank"
  validates_presence_of :description, :on => :create, :message => "can't be blank"
  validates_presence_of :domain_name, :on => :create, :message => "can't be blank"
  validates_presence_of :first_name, :on => :create, :message => "can't be blank"
  validates_presence_of :last_name, :on => :create, :message => "can't be blank"
  validates_presence_of :cpanel_username, :on => :create, :message => "can't be blank - put don't know if you don't know it"
  validates_presence_of :cpanel_password, :on => :create, :message => "can't be blank - put don't know if you don't know it"
  validates_length_of :description, :minimum => 15, :on => :create, :message => "is too short. Please describe the problem completely, including step-by-step instructions to help our tech team reproduce the issue"
  validates_format_of :email, :with => /(\S+)@(\S+)/ , :message => "is invalid, please use a valid email with an @ sign"
  validates_presence_of :department, :on => :create, :message => "is blank, please choose a department"
end
