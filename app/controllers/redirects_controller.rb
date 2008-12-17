class RedirectsController < ApplicationController
  
  require_role "Administrator"
  
  # GET /redirects
  # GET /redirects.xml
  def index
    @redirects = Redirect.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @redirects }
    end
  end

  # GET /redirects/1
  # GET /redirects/1.xml
  def show
    @redirect = Redirect.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @redirect }
    end
  end

  # GET /redirects/new
  # GET /redirects/new.xml
  def new
    @redirect = Redirect.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @redirect }
    end
  end

  # GET /redirects/1/edit
  def edit
    @redirect = Redirect.find(params[:id])
  end

  # POST /redirects
  # POST /redirects.xml
  def create
    @redirect = Redirect.new(params[:redirect])

    respond_to do |format|
      if @redirect.save
        flash[:notice] = 'Redirect was successfully created.'
        format.html { redirect_to(@redirect) }
        format.xml  { render :xml => @redirect, :status => :created, :location => @redirect }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @redirect.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /redirects/1
  # PUT /redirects/1.xml
  def update
    @redirect = Redirect.find(params[:id])

    respond_to do |format|
      if @redirect.update_attributes(params[:redirect])
        flash[:notice] = 'Redirect was successfully updated.'
        format.html { redirect_to(@redirect) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @redirect.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /redirects/1
  # DELETE /redirects/1.xml
  def destroy
    @redirect = Redirect.find(params[:id])
    @redirect.destroy

    respond_to do |format|
      format.html { redirect_to(redirects_url) }
      format.xml  { head :ok }
    end
  end
end
