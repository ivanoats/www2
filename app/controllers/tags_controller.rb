class TagsController < ApplicationController
  
  before_filter :check_editor_role, :except => [:index, :show] 

  def index
    # add in other things that can be tagged here and in the view
    @article_tags = Article.tag_counts :order => 'count desc'

    respond_to do |wants| 
      wants.html 
      wants.xml  { render :xml => @articles.to_xml } 
      wants.rss  { render :action => 'rss.rxml', :layout => false } 
      wants.atom { render :action => 'atom.rxml', :layout => false } 
    end 
  end

  def show 
    @tag = params[:id]
    @articles = Article.find_tagged_with(@tag)
    respond_to do |wants| 
      wants.html 
      wants.xml { render :xml => @article.to_xml } 
    end 
  end
  
  # def new  
  #   @article = Article.new 
  # end 
  # 
  # def create 
  #   logger.info params[:article].fetch(tags)
  #   @article = Article.create(params[:article]) 
  #   # article tags
  #   @logged_in_user.articles << @article 
  #   respond_to do |wants| 
  #     wants.html { redirect_to admin_articles_url } 
  #     wants.xml  { render :xml => @article.to_xml } 
  #   end 
  # end 
  # 
  # def edit 
  #   @article = Article.find(params[:id]) 
  # end 
  # 
  # def update 
  #   @article = Article.find(params[:id]) 
  #   @article.update_attributes(params[:article]) 
  #   respond_to do |wants| 
  #     wants.html { redirect_to admin_articles_url } 
  #     wants.xml  { render :xml => @article.to_xml } 
  #   end 
  # end 
  # 
  # def destroy 
  #   @article = Article.find(params[:id]) 
  #   @article.destroy 
  #   respond_to do |wants| 
  #     wants.html { redirect_to admin_articles_url } 
  #     wants.xml  { render :nothing => true } 
  #   end 
  # end 
  # 
  # def admin 
  #   @articles_pages, @articles = paginate(:articles, :order => 'published_at DESC') 
  # end 
 
end
