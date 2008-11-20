class ArticlesController < ApplicationController
  
  before_filter :check_editor_role, :except => [:index, :show, :permalink]

  def index
    @article_tags = Article.tag_counts :order => 'count desc', :at_least => 3 
    if params[:category_id]
        @kb = true if params[:category_id] == "2"
        @kb = true if request.path == "/faq" or request.path == "/kb" or request.path == "/knowledgebase" 
        
        @articles_pages, @articles = paginate(:articles, 
          :include => :user, 
          :order => 'created_at DESC', 
          :conditions => "category_id=#{params[:category_id].to_i} AND published=true") 
      elsif params[:search]
        #@articles = Article.search(params[:search])
        @kb = true
        @articles_pages, @articles = paginate(:articles,
          :include => :user,
          :conditions => ['(body LIKE ?) AND published = true',"%#{params[:search]}%" ])
      else 
        #@articles = Article.find_all_by_published(true) 
        @articles_pages, @articles = paginate(:articles, 
          :include => :user, 
          :order => 'created_at DESC', 
          :conditions => "published = true")        
      end 
      respond_to do |wants| 
        wants.html 
        wants.xml  { render :xml => @articles.to_xml } 
        wants.rss  { render :action => 'rss.rxml', :layout => false } 
        wants.atom { render :action => 'atom.rxml', :layout => false } 
      end 
  end

  def permalink
    @article = Article.find_by_permalink(params[:permalink])
    respond_to do |format|
       format.html { render :action => 'show' }
       format.xml  { render :xml => @article.to_xml }
     end
  end

  def show 
    if logged_in? && current_user.has_role?('Editor') 
      @article = Article.find(params[:id])
    else 
      @article = Article.find_by_id_and_published(params[:id], true) 
    end 
    respond_to do |wants| 
      wants.html 
      wants.xml { render :xml => @article.to_xml } 
    end 
  end
  
  def new  
    @article = Article.new 
  end 

  def create 
    @article = Article.new(params[:article]) 
    respond_to do |wants| 
      if @article.save
        flash[:notice] = "article saved"
        @logged_in_user.articles << @article 
        wants.html { redirect_to admin_articles_url } 
        wants.xml  { render :xml => @article.to_xml }
      else
        wants.html { render :action => "new" } 
        wants.xml  { render :xml => @article.errors, :status => :unprocessable_entity } 
      end
    end 
  end 

  def edit 
    @article = Article.find(params[:id]) 
  end 

  def update 
    @article = Article.find(params[:id]) 
    respond_to do |wants| 
      if @article.update_attributes(params[:article]) 
        flash[:notice] = "article updated"
        wants.html { redirect_to admin_articles_url } 
        wants.xml  { render :xml => @article.to_xml } 
      else
          wants.html { render :action => "update" } 
          wants.xml  {render :xml => @article.errors, :status => :unprocessable_entity }   
      end
    end
  end 

  def destroy 
    @article = Article.find(params[:id]) 
    @article.destroy 
    respond_to do |wants| 
      wants.html { redirect_to admin_articles_url } 
      wants.xml  { render :nothing => true } 
    end 
  end 
  
  def admin 
    @articles_pages, @articles = paginate(:articles, :order => 'published_at DESC') 
  end 
 
end
