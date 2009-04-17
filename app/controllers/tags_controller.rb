class TagsController < ApplicationController
  
  require_role "Editor", :except => [:index, :show] 

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
    @tag = Tag.find_by_name(params[:id])
    @articles = Article.find_tagged_with(@tag.name)
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
  #   current_user.articles << @article 
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
