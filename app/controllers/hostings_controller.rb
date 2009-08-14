class HostingsController < ApplicationController
  include ModelControllerMethods
  before_filter :get_server
  
private
  def get_server
    @server = Server.find(params[:server_id])
  end
  
  
end
