class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def comment_params
    params.require(:comment).permit(:body)
  end
  def create
    @comment = Comment.new comment_params
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:discussion_id]
    @comment.user = current_user
    @comment.discussion = @discussion
    if @comment.save
      redirect_to project_discussion_path(@project, @discussion)
    else
      render "/discussions/show"
    end
  end

  def edit
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:discussion_id]
    @comment = Comment.find params[:id]
  end

  def update
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:discussion_id]
    @comment = Comment.find params[:id]
    comment_params = params.require(:comment).permit(:body)
    if @comment.update comment_params
      redirect_to project_discussion_path(@project, @discussion)
    else
      redirect_to edit_project_discussion_comment_path(@project, @discussion, @comment)
    end
  end

  def destroy
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:discussion_id]
    @comment = Comment.find params[:id]
    @comment.destroy
    redirect_to project_discussion_path(@project, @discussion), notice: "Comment deleted!"
  end

  private

  def authenticate_user!
    redirect_to new_sessions_path, alert: "please sign in" unless user_signed_in?
  end
end
