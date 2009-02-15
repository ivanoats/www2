class CommentsController < ApplicationController
  	
  	def create 
      @comment = Comment.new(params[:comment]) 
      respond_to do |wants| 
        if @comment.save
          flash[:notice] = "Comment saved"
          wants.html { redirect_to admin_comments_url } 
          wants.xml  { render :xml => @comment.to_xml }
          wants.js { render :update do |page|
            page.insert_html :bottom, 'comments', :partial => 'comments/comment', :locals => {:comment => @comment}
            page.visual_effect :highlight, 'comments', :duration => 3
            page << "$('#comment_form')[0].reset()"
            page.replace_html 'commentMessage', uniform_success_message(flash[:notice])
          end
          }
        else
          wants.html { render :action => "new" } 
          wants.xml  { render :xml => @comment.errors, :status => :unprocessable_entity } 
          wants.js { render :update do |page|
            page.replace_html 'notice', ''
            page.select("#errorExplanation") { |e| e.replace_html '' } 
            page.replace_html 'commentMessage', error_messages_for(:comment)
          end
          }
        end
      end 
    end
end
