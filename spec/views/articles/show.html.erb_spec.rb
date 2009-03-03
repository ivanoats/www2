require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Article show page" do
  before(:each) do
    # @article = mock_model(Article)
    # @article.should_receive(:title).and_return("test_for_title")
    # @article.should_receive(:body).and_return('body of home page')
    # @article.should_receive(:synopsis).and_return('synpoz')
    # @article.should_receive(:category).and_return(mock_model(Category))
    
    @article = create_article
    #debugger
    
    assigns[:comment] = Comment.new
    assigns[:article] = @article
  end
  
  it "should show the article" do
    render "/articles/show.html.erb"
    response.should include_text(@article.title)
    response.should_not include_text('comments')
  end
  
  it "should show comments when enabled " do
    @article.update_attribute(:comments_enabled,true)
    
    render "/articles/show.html.erb"
    response.should include_text('comments')
  end
    
  it "should show the author of the article" do
    @article.stub!(:user).and_return mock_model(User, :name => "Test Author", :login => "testauthor")
    render "/articles/show.html.erb"
    response.should include_text('Test Author')
  end
end

