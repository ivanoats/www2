require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "Article Test",  
      :body => "stub for article test",
      :synopsis => "synopz"
    }
    @article = Article.new(@valid_attributes)
  end

  describe "being created" do
    
    it "should create an Article given valid attributes" do
      @article.should be_valid
    end
  
    it "should create an Article with a blank permalink" do
      @article = Article.new(@valid_attributes.merge(:permalink => ''))
      @article.should be_valid
    end
  
  end
  
  describe "creating a permalink" do
  
    it "from the title" do
      @article.save
      @article.permalink.should == PermalinkFu.escape(@article.title)
    end
   
   
    it "from a sentance" do
      @article.permalink = "This is the new link"
      @article.save
      @article.permalink.should == "this-is-the-new-link"
    end
  end
  
  describe "when updated" do
  
    it "should update permalink when link is changed" do 
      @article.update_attributes(:permalink => "new_link")
      @article.update_attribute(:permalink,"Changed")
      @article.permalink.should == "changed"
    end
  
    it "should use title when permalink is saved as blank" do
      @article.update_attributes(:permalink => "temppermalink")
      @article.permalink.should == "temppermalink"

      @article.update_attribute(:permalink,"")
      @article.permalink.should == "article-test"  
    end
    
    it "should keep permalink when title is changed" do
      @article.update_attributes(:permalink => "staythesame")
      @article.update_attributes(:title => "new title")
      @article.permalink.should == "staythesame"
    end
  end
  
end
