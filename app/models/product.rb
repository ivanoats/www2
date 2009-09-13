class Product < ActiveRecord::Base
  include AASM
  KINDS = %w(package domain addon coupon)

  belongs_to :whmappackage

  validates_presence_of :name
  validates_inclusion_of :kind, :in => KINDS, :message => "%s is not a valid kind"
  
  named_scope :packages, :conditions => {:kind => 'package' }
  named_scope :addons, :conditions => {:kind => 'addon'}
  named_scope :coupons, :conditions => {:kind => 'coupon'}
  
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
    Product.find_by_kind('domain') || Product.create!(:name => "Domain Name", :description => "Domain Name", :kind => 'domain', :cost => '10.00', :recurring_month => 1, :status =>  'active')
  end
  
  def period
    case self.recurring_month
    when 12
      1.year # 1.year != 12.months
    else
      self.recurring_month.months
    end
  end
  
  def period_in_words
    case recurring_month
    when 12
      'yearly'
    when 1
      'monthly'
    else
      "every #{recurring_month} months"
    end
  end
  
end
