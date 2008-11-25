class FourOhFoursController < ApplicationController

  def index
    cleaned_path = request.path.gsub(/\//," ").strip
    #if request.path is in the set of page permalinks then redirect to that page
    @page = Page.find_by_permalink(cleaned_path)
    
    render :partial => 'pages/show', :layout => "application" and return false if @page
    #redirect_to page_permalink_url(to_page.permalink) and return false
    
    #same if it is an article name
    @article = Article.find_by_permalink(cleaned_path)
    redirect_to permalink_url(@article.permalink) and return false if @article

    
    #TODO: same if it a username?
    
    FourOhFour.add_request(request.host, request.path, request.env['HTTP_REFERER'] || '') 
    respond_to do |format| 
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" } 
        format.all { render :nothing => true, :status => "404 Not Found" } 
    end
  end
end

