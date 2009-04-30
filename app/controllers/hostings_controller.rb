class HostingsController < ApplicationController
  before_filter :get_server
  
  # GET /hostings
  # GET /hostings.xml
  def index
    @hostings = Hosting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hostings }
    end
  end

  # GET /hostings/1
  # GET /hostings/1.xml
  def show
    @hosting = Hosting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hosting }
    end
  end

  # GET /hostings/new
  # GET /hostings/new.xml
  def new
    @hosting = Hosting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hosting }
    end
  end

  # GET /hostings/1/edit
  def edit
    @hosting = Hosting.find(params[:id])
  end

  # POST /hostings
  # POST /hostings.xml
  def create
    @hosting = Hosting.new(params[:hosting])

    respond_to do |format|
      if @hosting.save
        flash[:notice] = 'Hosting was successfully created.'
        format.html { redirect_to(@hosting) }
        format.xml  { render :xml => @hosting, :status => :created, :location => @hosting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hosting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hostings/1
  # PUT /hostings/1.xml
  def update
    @hosting = Hosting.find(params[:id])

    respond_to do |format|
      if @hosting.update_attributes(params[:hosting])
        flash[:notice] = 'Hosting was successfully updated.'
        format.html { redirect_to(@hosting) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hosting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hostings/1
  # DELETE /hostings/1.xml
  def destroy
    @hosting = Hosting.find(params[:id])
    @hosting.destroy

    respond_to do |format|
      format.html { redirect_to(hostings_url) }
      format.xml  { head :ok }
    end
  end
private
  def get_server
    @server = Server.find(params[:server_id])
  end
end
