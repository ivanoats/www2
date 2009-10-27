require '../lib/whmxml'

# require 'rubygems'
# require 'whmxml'

host = 'r15.nswebhost.com'
port = 2087
user = 'swcom13'
password = '99BottlesOfBeer!!'

@xml = Whm::Xml.new(host,port,user,password)

FileUtils::mkdir 'fixtures' unless File.exists?('fixtures')

# %w( version listaccts listpkgs gethostname createacct).each do |key|
#   File.open("fixtures/#{key}.xml",'w') { |f| f.write @xml.get_xml(key) }
# end

#I cannot get ssl to work
# %w( generatessl?xemail=test@domain.com&host=domain.com&country=US&state=TX&city=Houston&co=Domain%20LLC&cod=Web&pass=password ).each do |key|
#   File.open("fixtures/#{key}.xml",'w') { |f| f.write @xml.get_xml(key) }
# end
# 

#pp @xml.list_accounts

# %w( limitbw&user=padraic&bwlimit=1 ).each do |key|
#   File.open("fixtures/#{key}.xml",'w') { |f| f.write @xml.get_xml(key) }
# end


Whm::Account.xml = @xml

@xml.connection.debug = true
#pp Whm::Account.all

account =  Whm::Account.all.first
pp account
pp account.name
pp account.email