require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do
  
  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end
  
  describe "Anybody" do

    it "should add a comment" do
      c = Comment.count
      post 'create', :comment => {:email => 'email@example.com', :comment => "New Comment", :commentable_id => 1, :commentable_type => "Article", :key => COMMENT_KEY}
      response.should be_success
      Comment.count.should == (c + 1)
    end
    
    it "should not add a comment with a missing key" do
      c = Comment.count
      post 'create', :comment => {:email => 'email@example.com', :comment => "New Comment", :commentable_id => 1, :commentable_type => "Article", :key => nil}
      response.should be_success
      Comment.count.should == c #remain the same
      # 'no valid key' should be in error message
      response.body.should include('no valid key')
    end
    
    it "should not add a comment with a link in it" do
      c = Comment.count
      post 'create', :comment => {:email => 'email@example.com', :comment => "New Comment <a href=\"http://spam-site.com\"", :commentable_id => 1, :commentable_type => "Article", :key => COMMENT_KEY}
      response.should_not be_success
      Comment.count.should == c #remains the same
      response.body.should include('Comment Rejected')
    end
  end
  
end