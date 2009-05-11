require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hosting do
  
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
      assert_equal Hosting.charge_due, [hosting]
    end
    
    it 'should not be due' do
      hosting = create_hosting(:next_charge_on => 1.day.from_now)
      assert_equal Hosting.charge_due, []
    end
  end
  
  describe 'when billing yearly' do
    it 'should be due' do
      hosting = create_hosting(:product => default_product(:recurring_month => 12), :next_charge_on => 1.day.ago)
      assert_equal Hosting.charge_due, [hosting]
    end
    
    it 'should not be due' do
      hosting = create_hosting(:product => default_product(:recurring_month => 12), :next_charge_on => 1.day.from_now)
      assert_equal Hosting.charge_due, []
    end
    
  end

end


