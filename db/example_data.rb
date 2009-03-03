module FixtureReplacement
  attributes_for :article do |a|
    a.title = String.random(10)
    a.synopsis = 'Rut Ro'
    a.body = 'When Mummies Attack'
#    a.user =  what do I put here?
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

  attributes_for :page do |a|
    
	end

  attributes_for :password do |a|
    
	end

  attributes_for :product do |a|
    
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
    
	end

end