class Category < ActiveRecord::Base
  has_many :articles, :dependent => :nullify
  validates_length_of :name, :maximum => 80
  validates_uniqueness_of :name
  #validates_exclusion_of :name, :in => [' ','&','%', '/'] , :on => :create, :message => "spaces, ampersands, slashes and percentage signs are not allowed"
  validates_format_of :name, :with => %r{\A[^&%/\s]*\z}, :message => "spaces, ampersands, slashes and percentage signs are not allowed"
end
