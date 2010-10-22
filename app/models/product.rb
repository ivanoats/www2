# a product for sale
class Product < ActiveRecord::Base
  include AASM
  KINDS = %w(package domain addon coupon)
  STATUS = %w(enabled disabled)

  belongs_to :whmappackage

  validates_presence_of :name
  validates_inclusion_of :kind, :in => KINDS, :message => "%s is not a valid kind"
  validates_inclusion_of :status, :in => STATUS, :message => "%s is not a valid status"
  # TODO why did we want to disallow free products?
  validates_numericality_of :cost, :greater_than_or_equal_to => 0
  
  
  named_scope :packages, :conditions => {:kind => 'package' }
  named_scope :addons, :conditions => {:kind => 'addon'}
  named_scope :coupons, :conditions => {:kind => 'coupon'}
  
  named_scope :purchased, :conditions => {:purchased => true}
  named_scope :free, :conditions => {:purchased => false}

  serialize :data, Hash

  aasm_column :status
  aasm_initial_state :enabled
  aasm_state :enabled
  aasm_state :disabled

    
  aasm_event :enable do
    transitions :from => :disabled, :to => :enabled
  end
  
  aasm_event :disable do
    transitions :from => :enabled, :to => :disabled
  end

  def self.domain
    Product.find(:first, :conditions => {:kind => 'domain', :cost => 10.00}) || Product.create!(:name => "Domain Name", :description => "Domain Name", :kind => 'domain', :cost => 10.00, :recurring_month => 12, :status =>  'active')
  end
  
  def self.free_domain
    Product.find(:first, :conditions => {:kind => 'domain', :cost => 0.00}) || Product.create!(:name => "Free Domain Name", :description => "Free Domain Name", :kind => 'domain', :cost => 0.00, :recurring_month => 12, :status =>  'active')
  end
  
  # Returns the recurring period - number of months
  # @return [Integer] the recurring period - number of months
  def period
    case self.recurring_month
    when 12
      1.year # 1.year != 12.months
    else
      self.recurring_month.months
    end
  end
  
  # Returns the recurring period in words
  # @return [String] the period in words
  def period_in_words
    case recurring_month
    when 12
      'yearly'
    when 1
      'monthly'
    when 0
      "once"
    else
      "every #{recurring_month} months"
    end
  end
  
end
