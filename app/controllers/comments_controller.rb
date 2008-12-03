class CommentsController < ApplicationController
  	
  	# create a new comment on a blog post
    def create
      @comment = Comment.new(params[:comment])
      @comment.commentable = Article.find(params[:article_id]) if params[:article_id]
      
      render :update do |page|
        unless @comment.save 
          page.alert "The comment could not be added for the following reasons:\n" + 
                     @comment.errors.full_messages.join("\n") 
        else 
          page.insert_html :bottom, 'comments', :partial => 'comments/comment', :locals => {:comment => @comment}
          page.visual_effect :highlight, 'comments', :duration => 3
          page.form.reset 'comment_form' 
        end 
      end
    end
    
    # create a new comment on a writing
    # def new_writing_comment
    #   @writing = Writing.find(params[:id])
    # 
    #   @comment = Comment.new(params[:comment])
    #   @comment.created_at = Time.now
    #   @writing.comments << @comment
    #   render :layout=>false
    # end
end
