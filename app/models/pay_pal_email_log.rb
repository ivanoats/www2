class PayPalEmailLog < ActiveRecord::Base
  validates_uniqueness_of :messageid
end
