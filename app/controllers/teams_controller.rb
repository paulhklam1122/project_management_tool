class TeamsController < ApplicationController
 def index
 end

 def new
    @team = Team.new
 end

 def create
   @project = Project.find params[:project_id]
   t = Team.new(project: @project, user: current_user)
   if t.save
     redirect_to project_path(@project), notice: "Team created!"
   else
     redirect_to project_path(@project), notice: "Failed"
   end
 end

 def destroy
   @project = Project.find params[:project_id]
   @team = Team.find params[:id]
   @team.destroy #if can? :destroy, Favourite
   redirect_to project_path(@project), notice: "Team removed!"
 end
end
