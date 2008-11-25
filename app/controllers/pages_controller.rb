class PagesController < ApplicationController

  attr_accessor :splash_on
  
  require_role "Administrator", :except => [:show, :home, :permalink]

  def index
    @pages = Page.find(:all)
  end

  def permalink
    @page = Page.find_by_permalink(params[:permalink])
    respond_to do |format|
       format.html { render :partial => 'show' }
       format.xml  { render :xml => @page.to_xml }
     end
  end


  def show
    @page = Page.find(params[:id].to_i)
    render :partial => 'show'
  end

  def home
    @page = Page.find(1)
    @splash_on = true
  end

  def new
    @page = Page.new 
  end

  def create
     @page = Page.new(params[:page]) 
     @page.save! 
     flash[:notice] = 'Page saved' 
     redirect_to :action => 'index' 
   rescue ActiveRecord::RecordInvalid 
     render :action => 'new'
  end

  def edit
    @page = Page.find(params[:id].to_i)
    #@page = Page.find_by_permalink(params[:permalink])
  end

  def update
      @page = Page.find(params[:id].to_i)
      #@page = Page.find_by_permalink(params[:permalink])
      @page.attributes = params[:page] 
      @page.save! 
      flash[:notice] = "Page updated" 
      redirect_to :action => 'index' 
    rescue 
      render :action => 'edit' 
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
