class AddOn < ActiveRecord::Base
  belongs_to :product
  belongs_to :hosting
  
  include Chargeable
  before_create :initialize_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
end
