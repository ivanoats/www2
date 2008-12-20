class Redirect < ActiveRecord::Base
  validates_url_format_of :url,
                          :allow_nil => false,
                          :message => 'is not a valid url'
end
