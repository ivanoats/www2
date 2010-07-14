class CommentsController < ApplicationController
  
  def create
      # ensure what user is commenting ON is passed to new comment 
      comment_hash = params[:comment]
      #comment_hash[:commentable_id] = params[:commentable_id]
      #comment_hash[:commentable_type] = params[:commentable_type]
      @comment = Comment.new(comment_hash) 
      
      respond_to do |wants|

      if @comment.key == COMMENT_KEY
        if @comment.save
          flash[:notice] = "Comment saved"
          wants.xml  { render :xml => @comment.to_xml }
          wants.js { render :update do |page|
            page.insert_html :bottom,
                             'comments',
                             :partial => 'comments/comment',
                             :locals => {:comment => @comment}
            page.visual_effect :highlight, 'comments', :duration => 3
            page << "$('#comment_form')[0].reset()"
            page.replace_html 'commentMessage', uniform_success_message(flash[:notice])
          end # js render update
          }
        else # if comment not saved
          # wants.html { render :action => "new" } 
          wants.xml  { render :xml => @comment.errors, :status => :unprocessable_entity } 
          wants.js { render :update do |page|
            page.replace_html 'notice', ''
            page.select("#errorExplanation") { |e| e.replace_html '' } 
            page.replace_html 'commentMessage', error_messages_for(:comment)
          end # render update
          }
        end # if comment saved/ not saved
<<<<<<< HEAD
      else # if comment key does not match
=======
      else # if not comment key
>>>>>>> 5233f80cf54edfa2b7e0edefc9fe2cac21a682bd
        wants.js { render :update do |page|
          page.replace_html 'notice',''
          page.select("#errorExplanation") { |e| e.replace_html ''}
          page.replace_html 'commentMessage', "no valid key"
        end # render update
      }
      end # if comment key
    end # respond to
  end # create method
end # class comments controller
