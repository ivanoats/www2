class Product < ActiveRecord::Base
  STATUS = %w(active disabled)
  KINDS = %w(package domain addon)
  
  serialize :data, Hash
  
  validates_presence_of :name
  validates_numericality_of :cost, :greater_than => 0
  validates_inclusion_of :status, :in => STATUS, :message => "%s is not a valid status"
  validates_inclusion_of :kind, :in => KINDS, :message => "%s is not a valid kind"
  
  named_scope :packages, :conditions => {:kind => 'package' }
  named_scope :addons, :conditions => {:kind => 'addon'}

  def self.domain
    Product.find_by_kind('domain') || Product.create!(:name => "Domain Name", :description => "Domain Name", :kind => 'domain', :cost => '10.00', :recurring_month => 1, :status =>  'active')
  end
  
end
