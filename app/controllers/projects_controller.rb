.class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :authorize_owner, only: [:edit, :destroy, :update]
  def index
    @projects = Project.order(created_at: :desc).page(params[:page]).per(8)
  end

  def show
    # @project = Project.find params[:id]
    @discussion = Discussion.new
    @task = Task.new
  end

  def new
    @project = Project.new
    @task = Task.new
  end

  def create
    project_params = params.require(:project).permit(:title, :description, :due_date, {tag_ids: []})
    @project = Project.new project_params
    @project.user = current_user
    if @project.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
    # @project = Project.find params[:id]
  end

  def update
    # @project = Project.find params[:id]
    project_params = params.require(:project).permit(:title, :description, :due_date, {tag_ids: []})
    if @project.update project_params
      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find params[:id]
    @project.destroy
    redirect_to projects_path
  end

  private

  def find_project
    @project = Project.find params[:id]
  end



end
