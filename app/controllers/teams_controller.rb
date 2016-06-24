class TeamsController < ApplicationController
  def index
  end

  def new
    @team = Team.new
  end

  def create
    @project = Project.find params[:project_id]
    members = params[:users].split(",")
    members.each do |member_first_name|
      user = User.find_by_first_name member_first_name
      t = Team.new(project: @project, user: user)
      t.save
    # if t.save
      redirect_to project_path(@project), notice: "Team created!"
    #  else
    #  redirect_to project_path(@project), notice: "Failed"
    end
  end

  def update
    @project = Project.find params[:project_id]
    members = params[:users].split(",")
    # @project.team_users = members.map{ |u| User.find_by(first_name: u) }
    @project.team_users = User.where(first_name: members)


    # binding.pry
    # members.each do |member_first_name|
    #   user = User.find_by_first_name member_first_name
    #   t = Team.update(project: @project, user: user)
    #   t.save
    # end
    # if t.save
    redirect_to project_path(@project), notice: "Team updated!"
  end


  def destroy
    @project = Project.find params[:project_id]
    @team = Team.find params[:id]
    @team.destroy #if can? :destroy, Favourite
    redirect_to project_path(@project), notice: "Team removed!"
  end
end
