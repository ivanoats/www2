class PagesController < ApplicationController

  attr_accessor :splash_on
  
  require_role "Administrator", :except => [:show, :home, :permalink]

  def index
    @pages = Page.find(:all)
  end

  def permalink
    @page = Page.find_by_permalink(params[:permalink])
    unless @page.nil? then
      @page_title = @page.title
      respond_to do |format|
         format.html { render :partial => 'show', :layout => "application" }
         format.xml  { render :xml => @page.to_xml }
      end
   else
     respond_to do |format| 
       format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" } 
       format.all { render :nothing => true, :status => "404 Not Found" } 
     end 
   end #if page existed
  end


  def show
    @page = Page.find(params[:id])
    @page_title = @page.title
    render :partial => 'show', :layout => "application"
  end

  def home
    @page = Page.find(1)
    @page_title = @page.title
    @splash_on = true
  end

  def new
    @page = Page.new 
  end

  def create
     @page = Page.new(params[:page]) 
     respond_to do |wants| 
       if @page.save
         flash[:notice] = "Page saved"
         wants.html { redirect_to pages_url } 
         wants.xml  { render :xml => @page.to_xml }
         wants.js { render :update do |page|
           page.redirect_to edit_page_url(@page)
         end
         }
       else
         wants.html { render :action => "new" } 
         wants.xml  { render :xml => @page.errors, :status => :unprocessable_entity } 
         wants.js { render :update do |page|
           page.replace_html 'notice', ''
           page.select("#errorExplanation") { |e| e.replace_html '' } 
           page.replace_html 'error', error_messages_for(:page)
         end
         }
       end
     end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id]) 
    respond_to do |wants| 
      if @page.update_attributes(params[:page]) 
        flash[:notice] = "Page updated"
        wants.html { redirect_to pages_url } 
        wants.xml  { render :xml => @page.to_xml } 
        wants.js { render :update do |page| 
          page.replace_html 'notice', "Page updated"
          page.replace_html 'error', ''
          page.select("#errorExplanation") { |e| e.replace_html '' } 
        end
        }
      else
        wants.html { render :action => "update" } 
        wants.xml  {render :xml => @page.errors, :status => :unprocessable_entity }
        wants.js { render :update do |page|
          page.replace_html 'notice', ''
          page.select("#errorExplanation") { |e| e.replace_html '' } 
          page.replace_html 'error', error_messages_for(:page)
        end
        }     
      end
    end
  end

  def destroy
    #@page = Page.find(params[:id].to_i)
    @page = Page.find_by_permalink(params[:permalink]) 
    if @page.destroy 
      flash[:notice] = "Page deleted" 
    else 
      flash[:error] = "There was a problem deleting the page" 
    end 
    redirect_to :action => 'index' 
  end
   
  def splash_on?
    @splash_on
  end
end
