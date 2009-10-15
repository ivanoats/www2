module ActiveMerchantHelper
  include ActiveMerchant::Billing

  def supported_payment_types
    ActiveMerchant::Billing::Base.gateway(:authorize_net).supported_cardtypes
  end
end