require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BillingSystem do
  include BillingSystem
  before(:each) do
    @user = create_user
    @account = create_account(:users => [@user])
    
    @product = create_product(:name => "Magic Hosting", :cost => 12.50, :status => 'active', :kind => 'package')
    
    @hosting = create_hosting(:product => @product, :account => @account)
  end

  it "should run a really long test" do
    accounts
    hostings
    
    
  end
  
  
end

# def accounts
#   Account.active.due.each do |account| 
#     amount = account.balance
#     if account.charge_balance 
#       BillingMailer.charge_success(account)
#     else
#       BillingMailer.charge_failure(account,amount)        
#     end
#   end
# end
# 
# def hostings
#   Hosting.active.due.each { |hosting| hosting.charge }
#   
# end
