class CommentsController < ApplicationController
  
  def create
      # ensure what user is commenting ON is passed to new comment 
      comment_hash = params[:comment]
      #comment_hash[:commentable_id] = params[:commentable_id]
      #comment_hash[:commentable_type] = params[:commentable_type]
      @comment = Comment.new(comment_hash) 
      
      respond_to do |wants| 
        if @comment.save
          flash[:notice] = "Comment saved"
          wants.xml  { render :xml => @comment.to_xml }
          wants.js { render :update do |page|
            page.insert_html :bottom, 'comments', :partial => 'comments/comment', :locals => {:comment => @comment}
            page.visual_effect :highlight, 'comments', :duration => 3
            page << "$('#comment_form')[0].reset()"
            page.replace_html 'commentMessage', zform_success_message(flash[:notice])
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
