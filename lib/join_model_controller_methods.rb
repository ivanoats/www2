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
      first_class.find(params["#{first_class_name.singularize}_id"]).send(last_class_name)
    end
    
    def object
      @obj = last_class.find(params["#{last_class_name.singularize}_id"])
    end
        
    def first_class
      Object.const_get(first_class_name.classify)
    end
    
    def first_class_name
      the_rest = cname.split('_')
      the_rest.pop
      the_rest.join('_')
    end
    
    def last_class
      Object.const_get(last_class_name.classify)
    end
    
    def last_class_name
      cname.split('_').pop
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