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
    # respond_to do |format|
      if @comment.save
        # CommentsMailer.notify_discussion_owner(@comment).deliver_now if should_notify?
        format.html {redirect_to project_discussion_path(@project, @discussion)}
        # format.js {render :create_success}
      else
        format.html {render "/discussions/show"}
        # format.js {render :create_failure}
      # end
    end
  end

  def edit
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:discussion_id]
    @comment = Comment.find params[:id]
    respond_to do |format|
      format.js {render :edit_toggle}
    end
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

  def should_notify?
    @discussion.user != current_user
  end
end
