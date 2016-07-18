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
    respond_to do |format|
      if @task.save
        format.html {redirect_to project_path(@project), notice: "Task created!"}
        format.js {render :create_success}
      else
        format.html {render "/projects/show"}
        format.js {render :create_failure}
      end
    end
  end

  def edit
    @task = Task.find params[:id]
    @project = @task.project
    respond_to do |format|
      format.js {render :edit_toggle}
    end
  end

  def update
    @project = Project.find params[:project_id]
    @task = Task.find params[:id]
    task_params = params.require(:task).permit(:title, :body)
    respond_to do |format|
      if @task.update task_params
        format.html {redirect_to project_path(@project)}
        format.js {render :update_success}
      else
        format.html {redirect_to edit_project_task_path(@project, @task)}
        format.js {render :update_failure}
      end
    end
  end

  def destroy
    @project = Project.find params[:project_id]
    @task = Task.find params[:id]
    @task.destroy
    respond_to do |format|
      format.html {redirect_to project_path(@project), notice: "Task deleted!"}
      format.js {render}
    end
  end

  def mark
    @project = Project.find params[:project_id]
    @task = Task.find params[:id]
    Task.mark @task
    respond_to do |format|
    TasksMailer.notify_task_owner(@task).deliver_now if @task.mark == "Undone" && should_notify?
      format.html {redirect_to project_path(@project)}
      format.js {render}
    end
  end

  private

  def should_notify?
    @task.user != current_user
  end
end
