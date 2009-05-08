class Photo < ActiveRecord::Base
  belongs_to  :album
  
  has_attached_file :data,
  :styles => {
    :thumb => "125x125#",
    :large => "640x480#"
  }
  
  validates_attachment_presence :data
  validates_attachment_content_type :data,
  :content_type => ['image/jpeg','image/pjpeg','image/jpg','image/gif','image/png']

end
