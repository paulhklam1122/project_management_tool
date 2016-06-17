class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def review_params
    params.require(:discussion).permit(:title, :body)
  end
  def create
    @discussion = Discussion.new review_params
    @project = Project.find params[:project_id]
    @discussion.user = current_user
    @discussion.project = @project
    if @discussion.save
      redirect_to project_path(@project)
    else
      render "/projects/show"
    end
  end

  def edit
    @discussion = Discussion.find params[:id]
    @project = @discussion.project
  end

  def update
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:id]
    discussion_params = params.require(:discussion).permit(:title, :body)
    if @discussion.update discussion_params
      redirect_to project_path(@project)
    else
      redirect_to edit_project_discussion_path(@project, @discussion)
    end
  end

  def show
    @discussion = Discussion.find params[:id]
    @project = Project.find params[:project_id]
    @comment = Comment.new
  end

  def destroy
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:id]
    @discussion.destroy
    redirect_to project_path(@project), notice: "Review deleted!"
  end

  private

  def authenticate_user!
    redirect_to new_sessions_path, alert: "please sign in" unless user_signed_in?
  end
end
