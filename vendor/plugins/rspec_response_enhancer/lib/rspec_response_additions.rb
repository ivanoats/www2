module Spec
  module Rails
    module Matchers
      #--------New methods
      class StatusEnhancer
        def initialize(options={})
          @options = options
        end
        def matches?(actual)
          @actual = actual
          @actual.send(@options[:status_verb]+'?')
        end
        def failure_message
          o = @options
          status_info_to_text "Status should be #{o[:status_verb]} but was #{response_info}"
        end
        def negative_failure_message
          failure_message.sub(/^Status should be/,"Status should not be")
        end
        def status_info_to_text text
          status_info.unshift(text).select {|x| x}.join "\n"
        end
      protected
        def status_info
          [redirect_info,render_info,flash_info,errors_info]
        end
      private
        def flash_info
          return unless @actual.has_flash?
          flash = []
          @actual.flash.each do |name,value|
            flash << "     :#{name} = #{value}"
          end
          " - Flash:\n"+flash.join("\n")
        end
        
        # - Errors on @address(Address):
        #     City can't be blank
        def errors_info
          return unless @actual.template_objects
          errors = []
          
          @actual.template.assigns.each do |name,assigned|
            #quack?
            next unless assigned.respond_to? :errors
            next unless assigned.errors.respond_to? :full_messages
            
            #errors?
            next if assigned.errors.full_messages.empty?
            
            #pretty print em
            errors << " - Errors on @#{name}(#{assigned.class}):\n     " +
              assigned.errors.full_messages.join("\n     ")
          end
          return if errors.empty?
          
          errors.join("\n")
        end
      
        # - redirected to http://test.host/users
        def redirect_info
          return unless @actual.redirect?
          " - redirected to #{@actual.redirect_url}"
        end
        
        # - rendered addresses/index
        def render_info
          return unless @actual.success?
          #" - rendered #{@actual.rendered_file}"
          "- rendered #{@actual.rendered}"
        end
      
        #Status should be success but was 302(redirect)
        def response_info
          status = :unknown?
          [:success?,:error?,:redirect?,:missing?].each do |status|
            break if @actual.send(status)
          end
          "#{@actual.response_code}(#{status.to_s[0..-2]})"
        end
      end
      
      #TODO use be_success etc. only is the object is a response
      def have_succeeded
        StatusEnhancer.new :status_verb => 'success'
      end
      alias :have_been_success :have_succeeded
      
      def have_redirected
        StatusEnhancer.new :status_verb => 'redirect' 
      end
      alias :have_been_redirect :have_redirected
      
      def have_failed
        StatusEnhancer.new :status_verb => 'error' 
      end
      alias :have_been_error :have_failed
      
      def have_missed
        StatusEnhancer.new :status_verb => 'missing' 
      end
      alias :have_been_missing :have_missed
    end#Matchers
  end#Rails
end#Spec