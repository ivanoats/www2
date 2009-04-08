class Product < ActiveRecord::Base
    validates_presence_of :name
    validates_presence_of :cost
end
