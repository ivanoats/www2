class Product < ActiveRecord::Base
  STATUS = %w(active disabled)
  KINDS = %w(package add-on)
  
  validates_presence_of :name
  validates_numericality_of :cost, :greater_than => 0
  validates_inclusion_of :status, :in => STATUS, :message => "%s is not a valid status"
  validates_inclusion_of :kind, :in => KINDS, :message => "%s is not a valid kind"
  
  named_scope :packages, :conditions => {:kind => 'package'}
end
