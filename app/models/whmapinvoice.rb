class Whmapinvoice < Whmap
  set_primary_key "iid"
  set_table_name "invoice"
  belongs_to :whmaphostingorder, :foreign_key => "oid"
  belongs_to :whmapuser, :foreign_key => "uid"
  
  def self.find_unpaid(options = {})
    with_scope :find => options do
      find_all_by_status(0)
    end
  end
  
  def self.find_paid(options = {})
    with_scope :find => options do
      find_all_by_status(1)
    end
  end
  
  def formatted_due_date
    Time.at(self.due_date).strftime('%Y-%m-%d')
  end
  
  def formatted_created
    Time.at(self.created).strftime('%Y-%m-%d')
  end
  
  def formatted_date_paid
    Time.at(self.daite_paid).strftime('%Y-%m-%d')
  end
  
  def formatted_payment_method
    case self.payment_method.to_i
    when 8 then "Authorize.net"
    when 6 then "2Checkout"
    when 4 then "Mail in"
    when 1 then "PayPal"
    end
  end
  
  def formatted_status
    self.status == 1 ? "paid" : "unpaid"
  end
  
  def paid?
    self.status == 1
  end
  
  # is a particular invoice due?
  def due?
    self.due_date < DateTime.yesterday.to_s.to_time.to_i
  end
  
  # finds unpaid invoices (except todays)
  def self.find_due
    find_unpaid(:conditions => [ "due_date <= ? ", DateTime.yesterday.to_s.to_time.to_i ] )
  end
  
  #finds invocies more than 5 days old
  def self.find_overdue
    find_unpaid(:conditions => [ "due_date <= ? ", Chronic.parse("5 days ago").to_i ] ) 
  end
  
  def self.find_warning_due
    find_unpaid(:conditions => {:due_date => Chronic.parse("15 days ago").to_i..Chronic.parse("5 days ago").to_i })
  end
  
end