class ArticlesController < ApplicationController
  
  require_role "Editor", :except => [:index, :show, :permalink, :livesearch]

  def index
    @article_tags = Article.tag_counts :order => 'count desc', :at_least => 3 
    if params[:category_id]
      @kb = true if params[:category_id] == "2"
      @kb = true if request.path == "/faq" or request.path == "/kb" or request.path == "/knowledgebase" 
      
      @articles = Article.paginate(:page => params[:page],
        :include => :user, 
        :order => 'created_at DESC', 
        :conditions => ["category_id=? AND published=?",params[:category_id].to_i,true]) 
    elsif params[:search]
      @kb = true
      @articles = Article.paginate(:page => params[:page],
        :include => :user,
        :conditions => ['(body LIKE ?) AND published = ?',"%#{params[:search]}%",true ])
    else 
      @articles = Article.paginate(:page => params[:page], 
        :include => :user, 
        :order => 'created_at DESC', 
        :conditions => ["published = ?",true])        
    end 
    respond_to do |wants| 
      wants.html 
      wants.xml  { render :xml => @articles.to_xml } 
      wants.rss  { render :action => 'rss.rxml', :layout => false } 
      wants.atom { render :action => 'atom.rxml', :layout => false } 
    end 
  end
  
  def livesearch
    @search = params[:search]
    search = "%#{params[:search]}%"
    @articles = Article.all(:conditions => ['(title LIKE ? or body LIKE ?) AND published = ?',search,search,true], :limit => 10)
    
    render :layout => false
  end

  def permalink
    @article = Article.find_by_permalink(params[:permalink])
    @comment = Comment.new
    
    redirect_to(:action => "index", :search => params[:permalink]) and return if @article.nil?
    
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
    
    redirect_to(:action => "index", :search => params[:id]) and return if @article.nil?
    
    
    @page_title = @article.title    
    @comment = Comment.new
    
    respond_to do |wants| 
      wants.html 
      wants.xml { render :xml => @article.to_xml } 
    end 
  end
  
  def new  
    @article = Article.new 
  end 

  def preview
    @article = Article.find_by_id(params[:id]) || Article.new
    @article.attributes = params[:article]
  end

  def create 
    @article = Article.new(params[:article]) 
    @article.user = current_user
    respond_to do |wants| 
      if @article.save
        flash[:notice] = "Article saved"
        wants.html { redirect_to admin_articles_url } 
        wants.xml  { render :xml => @article.to_xml }
        wants.js { render :update do |page|
          page.redirect_to edit_article_url(@article)
        end
        }
      else
        wants.html { render :action => "new" } 
        wants.xml  { render :xml => @article.errors, :status => :unprocessable_entity } 
        wants.js { render :update do |page|
          page.replace_html 'notice', ''
          page.select("#errorExplanation") { |e| e.replace_html '' } 
          page.replace_html 'error', error_messages_for(:article)
        end
        }
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
        flash[:notice] = "Article updated"
        wants.html { redirect_to admin_articles_url } 
        wants.xml  { render :xml => @article.to_xml } 
        wants.js { render :update do |page| 
          page.replace_html 'notice', "article updated"
          page.replace_html 'error', ''
          page.select("#errorExplanation") { |e| e.replace_html '' } 
        end
        }
      else
        wants.html { render :action => "update" } 
        wants.xml  {render :xml => @article.errors, :status => :unprocessable_entity }
        wants.js { render :update do |page|
          page.replace_html 'notice', ''
          page.select("#errorExplanation") { |e| e.replace_html '' } 
          page.replace_html 'error', error_messages_for(:article)
        end
        }     
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
    @articles = Article.paginate(:page => params[:page], :per_page => 10, :order => 'published_at DESC, created_at DESC') 
  end 
 
end
