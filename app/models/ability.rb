class Ability
  include CanCan::Ability
    def initialize(user)

      user ||= User.new
      can :manage, Project do |p|
        p.user == user
      end

      can :manage, Discussion do |dis|
        dis.user == user || dis.project.user == user
      end

      can :manage, Comment do |com|
        com.user == user || com.project.user == user
      end

      can :manage, Task do |task|
        task.user == user || task.project.user == user
      end

      if user.is_admin?
        can :manage, :all
      else
        can :read, :all
      end
  end
end
