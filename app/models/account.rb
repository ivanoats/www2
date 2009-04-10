class Account < ActiveRecord::Base
  #This is an organization level account that can have many users and hosting accounts
  #likewise an individual user can be associated with multiple accounts
  
  has_and_belongs_to_many :users
  
  has_many :hostings
  has_many :domains 

  attr_protected :balance
  has_many :payments

  has_one :subscription
  
  def check_subscription
    #TODO add to balance for each new successful 
    
    #update subscription amount if different than balance
    
    
  end
  
  # def should_bill?
  #     self.last_payment_on + self.payment_period < (Time.today + 1.day).at_beginning_of_day
  #   end
  #   
  #   def bill
  #     self.update_attribute(:last_payment_on, Date.today)
  #     self.account.update_attribute(:balance, self.account.balance - self.cost)
  #   end
  
  # def update_subscriptions
  #     #called periodically to update balance from subscriptions, ya?
  #     
  #   end
  #   
  #   def setup_subscription(amount)
  #     subscription = self.subscription || Subscription.new
  #     gateway = RecurringBilling::RecurringBillingGateway.get_instance(active_merchant_gateway)
  #     recurring_options = {
  #       :start_date => Date.today,
  #       :trial_days => 0,
  #       :interval => '1 m' #monthly
  #     }
  #   end
  # 
  #   def pay_balance
  #     
  #     
  #     
  #     subscription = Subscription.find_by_id(subscription_id)
  # 
  #     gw = RecurringBilling::RecurringBillingGateway.get_instance(@gateway)
  #     tariff = @all_tariff_plans[subscription.tariff_plan_id]
  #     recurring_options = {
  #             :start_date => subscription.starts_on,
  #             :trial_days => tariff['payment_term']['trial_days'],
  #             :end_date => subscription.ends_on,
  #             :interval => tariff['payment_term']['periodicity']
  #             }
  # 
  #     if payment_options[:subscription_name].nil?
  #       payment_options[:subscription_name] = @tariff_plans_namespace+': '+tariff['service']['name']
  #     end
  # 
  #     payment_options[:taxes_amount_included] = Money.new(subscription.taxes_amount,subscription.currency)
  # 
  #     gateway_id = gw.create(Money.new(subscription.billing_amount, subscription.currency), card, payment_options, recurring_options)
  #     if !gateway_id.nil?
  #       sp = SubscriptionProfile.new
  #       sp.subscription_id = subscription.id
  #       sp.recurring_payment_profile_id = RecurringPaymentProfile.find_by_gateway_reference(gateway_id).id
  #       sp.save
  #       subscription.status = 'ok'
  #       subscription.save
  #     else
  #       raise StandardError, 'Recurring payment creation error: ' + gw.last_response.message
  #     end
  #     
  #     
  #   end

end
