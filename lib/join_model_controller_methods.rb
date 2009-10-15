module JoinModelControllerMethods

  def create
    if scoper << object
      flash[:notice] = "The #{cname.humanize.downcase} has been created."
      redirect_back_or_default modified_redirect_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @result = scoper.delete(object)
    respond_to do |wants|
      wants.html do
        if @result
          flash[:notice] = "The #{cname.humanize.downcase} has been deleted."
        render :nothing => true
          #redirect_back_or_default redirect_url
        else
          render :action => 'show'
        end
      end
      
      wants.js do
        render :update do |page|
          if @result
            page.remove "#{@controller.controller_name}_#{@obj.id}"
          else
            page.alert "Errors deleting #{@obj.class.to_s.downcase}: #{@obj.errors.full_messages.to_sentence}"
          end
        end
      end
    end
  end
  
  protected

    def scoper
      Object.const_get(cname.classify)
    end
    
    def redirect_url
      { :action => 'index' }
    end
    
    def modified_redirect_url
      eval "#{cname}_path(@obj)"
    end
    
    def cname
      cname ||= self.controller_name
    end
end