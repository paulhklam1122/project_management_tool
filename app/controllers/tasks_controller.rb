class TasksController < ApplicationController
    before_action :authenticate_user!, except: [:show, :index]
  def index
    @tasks = Task.order("due_date").paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @task = Task.find params[:id]
    @project = @task.project
  end

  def new
    @task = Task.new
    @project = Project.find params[:project_id]
  end

  def create
    task_params = params.require(:task).permit(:title, :due_date)
    @task = Task.new task_params
    @project = Project.find params[:project_id]
    @task.user = current_user
    @task.project = @project
    if @task.save
      redirect_to project_path(@project)
    else
      render "/projects/show"
    end
  end

  def edit
    @task = Task.find params[:id]
    @project = @task.project
  end

  def update
    @project = Project.find params[:project_id]
    @task = Task.find params[:id]
    task_params = params.require(:task).permit(:title, :body)
    if @task.update task_params
      redirect_to project_path(@project)
    else
      redirect_to edit_project_task_path(@project, @task)
    end
  end

  def destroy
    @project = Project.find params[:project_id]
    @task = Task.find params[:id]
    @task.destroy
    redirect_to project_path(@project), notice: "Task deleted!"
  end

  def mark
    @project = Project.find params[:project_id]
    @task = Task.find params[:id]
    Task.mark @task
    redirect_to project_path(@project)
  end

  private

  def authenticate_user!
    redirect_to new_sessions_path, alert: "please sign in" unless user_signed_in?
  end
end
