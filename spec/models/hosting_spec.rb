require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hosting do
  
  it 'should generate a password' do
    @hosting = Hosting.new
    @hosting.generate_password
    assert_not_nil @hosting.password
  end
  
  it 'should generate a username' do
    @hosting = Hosting.new(:domains => [Domain.new(:name => 'google.com')])
    @hosting.generate_username
    assert_equal @hosting.username, 'google'
  end

  it 'should generate a username without a www' do
    @hosting = Hosting.new(:domains => [Domain.new(:name => 'www.google.com')])
    @hosting.generate_username
    assert_equal @hosting.username, 'google'
  end

  
  def generate_password
    self.password = Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}"))[0..7]
    
  end
  
  def generate_username
    #base the username on the first 8 characters of the domain name
    self.username = self.domains.first.name.gsub('www.','')
    self.username = self.username.slice(0,[self.username.rindex('.'),8].min)
    
    #convert from 'greenhut' to 'greenhu1'
    self.username = self.username[0,7] + "1" if Hosting.find_by_username(self.username)
    
    #increase last character until we find a unique name
    while !Hosting.find_by_username(self.username).nil?
      self.username.next!
    end  
  end
  
  
  it 'should automatically set next_charge_on' do
    hosting = create_hosting
    assert hosting.next_charge_on > 1.week.from_now
  end
  
  it 'should create when next_charge specified' do
    charge_time = 300.years.ago
    hosting = create_hosting(:next_charge_on => charge_time)
    assert_equal hosting.next_charge_on, charge_time
  end
  
  describe 'when billing monthly' do
    it 'should be due' do
      hosting = create_hosting(:next_charge_on => 1.day.ago)
      assert_equal Hosting.due, [hosting]
    end
    
    it 'should not be due' do
      hosting = create_hosting(:next_charge_on => 1.day.from_now)
      assert_equal Hosting.due, []
    end
  end
  
  describe 'when billing yearly' do
    it 'should be due' do
      hosting = create_hosting(:product => default_product(:recurring_month => 12), :next_charge_on => 1.day.ago)
      assert_equal Hosting.due, [hosting]
    end
    
    it 'should not be due' do
      hosting = create_hosting(:product => default_product(:recurring_month => 12), :next_charge_on => 1.day.from_now)
      assert_equal Hosting.due, []
    end
    
  end

end


