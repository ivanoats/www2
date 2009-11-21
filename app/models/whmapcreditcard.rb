# require "MCrypt"
# require 'digest/md5'
# require 'base64'

class Whmapcreditcard < Whmap
  set_primary_key "ccid"
  set_table_name "authnet_master_cc"
  belongs_to :whmapuser, :foreign_key => "uid"
    
  def number
    decrypt_card.split('|')[0].to_i
  end
  
  def month
    decrypt_card.split('|')[1][0..1].to_i
  end
  
  def year
    '20' + decrypt_card.split('|')[1][2..3]
  end
  
  def type
    decrypt_card.split('|')[2]
  end
  
  def card_type
    case decrypt_card.split('|')[2]
    when '0'
      'visa'
    else
      'unknown'
    end
  end
  
protected

  def decrypt_card
    key = "576cb7f68040520768bf51c75f7f4c84"
    iv = Digest::MD5.hexdigest(key)[0...16]
    crypto = Mcrypt.new('cast-256', :cfb, key, iv, nil)
    data = Base64.decode64(self.card_info).strip
    
    decrypted_card_number  = crypto.decrypt(data)
    decrypted_card_number.chomp('abcd').chomp('abc').strip!
    decrypted_card_number
    
    
    # key = "576cb7f68040520768bf51c75f7f4c84"
    # 
    # data = Base64.decode64(self.card_info).strip
    # iv = Digest::MD5.hexdigest(key)[0..16]
    # 
    # decrypted_card_number = MCrypt.new('cast-256', nil, 'cfb', nil, key, iv).mdecrypt_generic(data)
    # decrypted_card_number.chomp!('abcd').chomp('abc').strip!
    # decrypted_card_number
  end
  
  
end