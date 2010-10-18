require 'machinist/active_record'
require 'sham'
require 'faker'

# EXAMPLES FROM DOCUMENTATION: http://github.com/notahat/machinist/tree/1.0-maintenance

Sham.title { Faker::Lorem.sentence }
Sham.synopsis { Faker::Lorem.paragraph }
Sham.body  { Faker::Lorem.paragraph }

Address.blueprint do
  
  
end

Article.blueprint do 
  title
  synopsis
  body
  permalink { Sham.title }
  
end