require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  
  before(:each) do
    @valid_attributes = {
      :name => "comment tester", 
      :email => "valid_comment@email.com", 
      :comment => "stub for comment test",
      :commentable => mock_model(Article)
    }
  end
  
  it "should create a new Comment given valid attributes" do
    @page = Comment.create!(@valid_attributes)
    @page.should be_valid
  end
  
end
