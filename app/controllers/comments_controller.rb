class CommentsController < ApplicationController

def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.build(params[:comment].permit(:name, :body, :user_id))
  @comment.user_id = current_user.id
  @comment.save!
  redirect_to post_path(@post)
end

def destroy
  @post = Post.find(params[:post_id])
  @comment = @post.comments.find(params[:id])
  @comment.destroy
  redirect_to post_path(@post)
end
end
