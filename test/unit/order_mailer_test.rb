require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "complete" do
    @expected.subject = 'OrderMailer#complete'
    @expected.body    = read_fixture('complete')
    @expected.date    = Time.now

    assert_equal @expected.encoded, OrderMailer.create_complete(@expected.date).encoded
  end

  test "approved" do
    @expected.subject = 'OrderMailer#approved'
    @expected.body    = read_fixture('approved')
    @expected.date    = Time.now

    assert_equal @expected.encoded, OrderMailer.create_approved(@expected.date).encoded
  end

end
