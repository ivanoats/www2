class CertificateTicket < ActiveRecord::Base

  validates_presence_of :email, :host, :country, :state, :city, :company_name, :company_division, :password
  
  #validates_format_of :email, :with => /(\S+)@(\S+)/ , :message => "is invalid, please use a valid email with an @ sign"
  

end
