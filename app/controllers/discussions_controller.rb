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
    respond_to do |format|
      if @discussion.save
        format.html {redirect_to project_path(@project)}
        format.js {render :create_success}
      else
        format.html {render "/projects/show"}
        format.js {render :create_failure}
      end
    end
  end

  def edit
    @discussion = Discussion.find params[:id]
    @project = @discussion.project
    respond_to do |format|
      format.js {render :edit_toggle}
    end
  end

  def update
    @project = Project.find params[:project_id]
    @discussion = Discussion.find params[:id]
    discussion_params = params.require(:discussion).permit(:title, :body)
    respond_to do |format|
      if @discussion.update discussion_params
        format.html {redirect_to project_path(@project)}
        format.js {render :update_success}
      else
        format.html {redirect_to edit_project_discussion_path(@project, @discussion)}
        format.js {render :update_failure}
      end
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
    respond_to do |format|
      format.html {redirect_to project_path(@project), notice: "Review deleted!"}
      format.js {render}
    end
  end
end
