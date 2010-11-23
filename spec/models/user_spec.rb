# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe User do
  before(:each) do
    @user = User.make
    @user.register!
    @user.activate!
  end

  # fixtures :users

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = User.make
        violated "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end

    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end

    it 'initializes #activation_code' do
      @creating_user.call
      @user.reload
      @user.activation_code.should_not be_nil
    end

    it 'starts in passive state' do
      @creating_user.call
      @user.reload
      @user.should be_passive
    end
  end

  #
  # Validations
  #

  it 'requires login' do    
    user = User.make(:login => nil)
    user.errors.should_not be_nil
  end

  describe 'allows legitimate logins:' do
    ['123', '1234567890_234567890_234567890_234567890',
     'hello.-_there@funnychar.com'].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = User.make(:login => login_str)          
          u.errors.on(:login).should be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe 'disallows illegitimate logins:' do
    ['12', '1234567890_234567890_234567890_234567890_', "tab\t", "newline\n",
     "Iñtërnâtiônàlizætiøn hasn't happened to ruby 1.8 yet",
     'semicolon;', 'quote"', 'tick\'', 'backtick`', 'percent%', 'plus+', 'space '].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          User.make_unsaved(:login => login_str).should_not be_valid
        end.should_not change(User, :count)
      end
    end
  end

  it 'requires password' do
      u = User.make(:password => nil)
      u.errors.should_not be_nil
  end

  it 'requires password confirmation' do
    u = User.make(:password_confirmation => nil)
    u.errors.should_not be_nil
  end

  it 'requires email' do
    lambda do
      u = create_user(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(User, :count)
  end

  describe 'allows legitimate emails:' do
    ['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
     'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
     'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
     'domain@can.haz.many.sub.doma.in', 'student.name@university.edu'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_user(:email => email_str)
          u.errors.on(:email).should be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe 'disallows illegitimate emails' do
    ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
     'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
     'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
     # these are technically allowed but not seen in practice:
     'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_user(:email => email_str)
          u.errors.on(:email).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  describe 'allows legitimate names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
     '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:name => name_str)
          u.errors.on(:name).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe "disallows illegitimate names" do
    ["tab\t", "newline\n",
     '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
     ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:name => name_str)
          u.errors.on(:name).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  it 'resets password' do
    @user.update_attributes(:password => 'new_password', :password_confirmation => 'new_password')
    User.authenticate(@user.login, 'new_password').should == @user
  end

  it 'does not rehash password' do
    @user.update_attributes(:login => 'new_login')
    User.authenticate('new_login', @user.password).should == @user
  end

  #
  # Authentication
  #

  it 'authenticates user' do
    User.authenticate(@user.login, @user.password).should == @user
  end

  it "doesn't authenticate user with bad password" do
    User.authenticate(@user.login, 'invalid_password').should be_nil
  end

 # TODO: FIGURE OUT WHY THIS WAS HERE
 # if REST_AUTH_SITE_KEY.blank?
 #   # old-school passwords
 #   it "authenticates a user against a hard-coded old-style password" do
 #     User.authenticate('old_password_holder', 'test').should == users(:old_password_holder)
 #   end
 # else
   it "doesn't authenticate a user against a hard-coded old-style password" do
     User.authenticate('old_password_holder', 'test').should be_nil
   end

   # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
   desired_encryption_expensiveness_ms = 0.1
   it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
     test_reps = 100
     start_time = Time.now; test_reps.times{ User.authenticate(@user.login, @user.password+rand.to_s) }; end_time   = Time.now
     auth_time_ms = 1000 * (end_time - start_time)/test_reps
     auth_time_ms.should > desired_encryption_expensiveness_ms
   end
 # end

  #
  # Authentication
  #

  it 'sets remember token' do
    @user.remember_me
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    @user.remember_me
    @user.remember_token.should_not be_nil
    @user.forget_me
    @user.remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    @user.remember_me_for 1.week
    after = 1.week.from_now.utc
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    @user.remember_me_until time
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    @user.remember_me
    after = 2.weeks.from_now.utc
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token_expires_at.between?(before, after).should be_true
  end

  it 'registers passive user' do
    new_user = User.make(:password => nil, :password_confirmation => nil)
    new_user.should be_passive
    new_user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    new_user.register!
    new_user.should be_pending
  end

  it 'suspends user' do
    @user.suspend!
    @user.should be_suspended
  end

  it 'does not authenticate suspended user' do
    @user.suspend!
    User.authenticate('quentin', 'monkey').should_not == @user
  end

  it 'deletes user' do
    @user.deleted_at.should be_nil
    @user.delete!
    @user.deleted_at.should_not be_nil
    @user.should be_deleted
  end

  describe "being unsuspended" do
    fixtures :users

    before do
      @user = @user
      @user.suspend!
    end

    it 'reverts to active state' do
      @user.unsuspend!
      @user.should be_active
    end

    it 'reverts to passive state if activation_code and activated_at are nil' do
      User.update_all :activation_code => nil, :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_passive
    end

    it 'reverts to pending state if activation_code is set and activated_at is nil' do
      User.update_all :activation_code => 'foo-bar', :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_pending
    end
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
