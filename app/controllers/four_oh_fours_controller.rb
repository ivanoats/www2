class FourOhFoursController < ApplicationController

  def index
    cleaned_path = request.path.gsub(/\//," ").strip
    #if request.path is in the set of page permalinks then redirect to that page
    to_page = Page.find_by_permalink(cleaned_path)
    
    if to_page then
      redirect_to page_permalink_url(to_page.permalink) and return false
    end
    #same if it is an article name
    to_article = Article.find_by_permalink(cleaned_path)
    if to_article then
      redirect_to permalink_url(to_article.permalink) and return false
    end
    
    #TODO: same if it a username?
    
    FourOhFour.add_request(request.host, request.path, request.env['HTTP_REFERER'] || '') 
    respond_to do |format| 
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" } 
        format.all { render :nothing => true, :status => "404 Not Found" } 
    end
  end
end

