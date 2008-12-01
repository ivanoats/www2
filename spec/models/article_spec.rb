require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "ArticleTest",  
      :body => "stub for article test",
      :synopsis => "synopz"
    }
    @article = Article.new(@valid_attributes)
  end

  it "should create a new Article given valid attributes" do
     @article.should be_valid
   end
   
   it "should create a default permalink" do
     @article.save
     @article.permalink.should == PermalinkFu.escape(@article.title)
   end
   
   it "should create a permalink from a custom link" do
     @article.permalink = "new_link"
     @article.save
     @article.permalink.should == "new_link"
   end
  
  it "should update permalink when link is changed" do 
    @article.permalink = "new_link"
    @article.save
    @article.update_attribute(:permalink,"Changed")
    @article.permalink.should == "changed"
  end
  
  it "should use title when permalink is saved as blank" do
    @article.permalink = "temp_permalink"
    @article.save
    @article.permalink.should == "temp_permalink"

    @article.update_attribute(:permalink,"")
    @article.permalink.should == "articletest"
    
  end
  
end
