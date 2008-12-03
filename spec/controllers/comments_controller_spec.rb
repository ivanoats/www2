require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do

  describe "Anybody" do

    it "should add a comment" do
      c = Comment.count
      Article.should_receive(:find).and_return(Article.new)
      post 'create',:article_id => 100, :comment => {:email => 'email@example.com', :comment => "New Comment"}
      response.should be_success
      Comment.count.should == c + 1
    end
    
  end
  
end