class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user!
    redirect_to new_sessions_path, alert: "Please Sign In" unless user_signed_in?
  end

  def authorize_owner
    redirect_to root_path, alert: "Access Denied" unless can? :manage, @project
  end
  helper_method :authorize_owner

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_signed_in?
    session[:user_id].present?
  end
  helper_method :user_signed_in?

  def sign_in(user)
    session[:user_id] = user.id
  end
end
