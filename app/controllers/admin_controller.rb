class AdminController < ApplicationController
  layout 'admin'
  require_role "Administrator"
  
  before_filter :login_required
  
  def index
    @ordered = Hosting.ordered
    @due = Account.due
    @overdue = Account.overdue
    @server = Server.find_by_id(session[:provisioning_server]) || Server.last
    @domains = Domain.ordered
    @add_ons = AddOn.ordered
  end
  
  def provision
    if request.post? && params[:hosting]
      @server = Server.find(params[:server])
      @hostings = Hosting.find(params[:hosting].keys)
      @hostings.each { |hosting|
        hosting.update_attribute(:server,@server)
        hosting.activate!
      }
    end
    redirect_to :action => :index
  rescue => e
    flash[:error] = e.to_s
    redirect_to :action => :index
  end

  def approve
    if request.post? && params[:domain]
      @domains = Domain.find(params[:domain].keys)
      @domains.each { |domain|
        domain.activate!
      }
    end
    redirect_to :action => :index
  rescue => e
   flash[:error] = e.to_s
   redirect_to :action => :index
  end
  
  def complete
    if request.post? && params[:add_on]
      @add_ons = AddOn.find(params[:add_on].keys)
      @add_ons.each { |add_on| 
        if add_on.product.recurring_month == 0
          add_on.completed!
        else
          add_on.activate!
        end
      }
    end
    redirect_to :action => :index
  rescue => e
    flash[:error] = e.to_s
    redirect_to :action => :index
  end

end
