require 'machinist/active_record'
require 'sham'
require 'faker'

# EXAMPLES FROM DOCUMENTATION: http://github.com/notahat/machinist/tree/1.0-maintenance

Sham.title { Faker::Lorem.sentence }
Sham.synopsis { Faker::Lorem.paragraph }
Sham.body  { Faker::Lorem.paragraph }
Sham.email { Faker::Internet.email }
Sham.name  { Faker::Name.name }

Address.blueprint do
  
  
end

Article.blueprint do 
  title { Sham.title }
  synopsis
  body
  permalink { Sham.title }
end

User.blueprint do
  password {'testpass'}
  password_confirmation {'testpass'}
  login { (0...8).map{65.+(rand(25)).chr}.join }
  name { Sham.name }
  email { Sham.email }
  
end
