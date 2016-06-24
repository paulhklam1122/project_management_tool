class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = current_user.favourite_projects
  end
  def create
    project = Project.find params[:project_id]
    favourite = Favourite.new(project: project, user: current_user)
    if project.user != current_user
      if favourite.save
        redirect_to project_path(project), notice: "Thanks for favouriting!"
      else
        redirect_to project_path(project), notice: "Failed to favourite."
      end
    else
      redirect_to project_path(project), alert: "You cannot favourite your own project silly!!!!!!!"
    end
  end

  def destroy
    favourite = Favourite.find params[:id]
    project = Project.find params[:project_id]
    if can? :destroy, Favourite
      favourite.destroy
      redirect_to project_path(project), notice: "Un-favourited"
    else
      redirect_to project_path(project), alert: "Failed to Un-favourite"
    end
  end
end
