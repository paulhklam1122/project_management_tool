class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_params
    @user = User.new user_params
    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: "You're now signed up!"
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    user_params
    if @user.update user_params
      redirect_to root_path, notice: "User Information Updated!"
    else
      flash[:alert] = "This password you entered doesn't match the current password in our records."
      render :edit
    end
  end

  def change_password
    @user = User.find session[:user_id]
  end

  def update_password
    @user = User.find session[:user_id]
    if @user.authenticate(params[:password])
      if params[:new_password] == params[:new_password_confirmation]
        @user.update password: params[:new_password]
        redirect_to root_path, notice: "Password Successfully Changed!"
      else
        flash[:alert] = "Your new password and confirmation do not match."
        render :change_password
      end
    else
      flash[:alert] = "The password you entered doesn't match the one in our records."
      render :change_password
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
