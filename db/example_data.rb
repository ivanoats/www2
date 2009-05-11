module FixtureReplacement
  
  attributes_for :account do |a|
    a.users = [default_user]
    a.organization = 'Organization'
	end
  
  attributes_for :article do |a|
    a.title = String.random(10)
    a.synopsis = 'Rut Ro'
    a.body = 'When Mummies Attack'
    a.user =  default_user
	end

  attributes_for :category do |a|
    
	end

  attributes_for :comment do |a|
    a.title = 'Title'
    a.comment = 'Me for the win!'
    a.email = 'goofy@example.com'
    a.name = 'George Washington'
	end

  attributes_for :four_oh_four do |a|
    
	end
  
  attributes_for :hosting do |a|
    a.account = default_account
    a.product = default_product
	end
  
  attributes_for :page do |a|
    
	end

  attributes_for :password do |a|
    
	end

  attributes_for :product do |a|
    a.recurring_month = 1
    a.name = 'Package'
    a.kind = 'package'
    a.cost = 1
    a.status = 'active'
	end

  attributes_for :role do |a|
    
	end

  attributes_for :tagging do |a|
    
	end

  attributes_for :tag do |a|
    
	end

  attributes_for :ticket do |a|
    
	end

  attributes_for :user do |a|
    a.password = 'testpass'
    a.password_confirmation = 'testpass'
    a.login = 'testlogin'
    a.name = 'testauthor'
    a.email = 'arealemail@boo.com'
	end

end