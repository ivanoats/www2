class FourOhFoursController < ApplicationController

  def index
    cleaned_path = request.path.gsub(/\//," ").strip

    #checked cleaned_path against list of redirects in database
    logger.info("CLEANED PATH: " + cleaned_path)
    redirect = Redirect.find_by_slug(cleaned_path)
    redirect_to redirect.url and return unless redirect == nil
    
    #redirect_to  'https://billing.sustainablewebsites.com/step_one.php?gid=2' and return if cleaned_path.strip == 'cabn'

    #fake /:page_permalink
    @page = Page.find_by_permalink(cleaned_path)
    if @page
      @page_title = @page.title
      render :partial => 'pages/show', :layout => "application" and return false
    end
    
    #redirect to /article/:article_permalink
    @article = Article.find_by_permalink(cleaned_path)
    redirect_to permalink_url(@article.permalink) and return false if @article
    
    redirect_to articles_path(:search => cleaned_path) and return false
    
    FourOhFour.add_request(request.host, request.path, request.env['HTTP_REFERER'] || '') 
    respond_to do |format| 
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" } 
        format.all { render :nothing => true, :status => "404 Not Found" } 
    end
  end
end

