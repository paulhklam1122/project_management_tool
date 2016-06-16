class TasksController < ApplicationController
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
    @task.project = @project
    if @task.save
      redirect_to project_path(@project)
    else
      render "/projects/show"
    end
  end

  def edit
    @task = Task.find params[:id]
  end

  def update
    @task = Task.find params[:id]
    task_params = params.require(:task).permit(:title, :description, :due_date)
    if @task.update task_params
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find params[:project_id]
    @task = task.find params[:id]
    @task.destroy
    redirect_to project_path(@project), notice: "Task deleted!"
  end
end
