class CommentsController < ApplicationController
  	
  	# create a new comment on a blog post
    def new
      @comment = Comment.new(params[:comment])
      @comment.save
      render :layout => false
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
