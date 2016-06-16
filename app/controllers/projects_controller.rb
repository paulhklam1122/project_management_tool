class ProjectsController < ApplicationController
  def index
    @projects = Project.order("due_date").paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @project = Project.find params[:id]
    @discussion = Discussion.new
    @task = Task.new
  end

  def new
    @project = Project.new
    @task = Task.new
  end

  def create
    project_params = params.require(:project).permit(:title, :description, :due_date)
    @project = Project.new project_params
    if @project.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
    @project = Project.find params[:id]
  end

  def update
    @project = Project.find params[:id]
    project_params = params.require(:project).permit(:title, :description, :due_date)
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

end
