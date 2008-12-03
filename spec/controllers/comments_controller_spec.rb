require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do

  describe "Anybody" do

    it "should add a comment" do
      Article.should_receive(:find).and_return(Article.new)
      get 'new', :id => 100
      response.should be_success
      #TODO check comment actually created
    end
    
  end
  
end