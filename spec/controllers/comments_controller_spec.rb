require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do
  
  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end
  
  describe "Anybody" do

    it "should add a comment" do
      c = Comment.count
      post 'create', :comment => {:email => 'email@example.com', :comment => "New Comment", :commentable_id => 1, :commentable_type => "Article"}
      response.should be_success
      Comment.count.should == c + 1
    end
    
  end
  
end