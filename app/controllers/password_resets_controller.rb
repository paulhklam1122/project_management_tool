class PasswordResetsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email params[:email]
    if @user
      token = password_reset_token
      @user.update password_reset_token: token
      @user.update password_reset_sent_at: Time.zone.now
      render text: edit_password_reset_path(@user) + "/?token=#{token}"
      #email sent to the email address
      # flash[:notice] = "Email has been sent"
      # redirect_to root_path
    else
      flash[:alert] = "Email is not found"
      redirect_to new_password_reset_path
    end
  end

  def edit
    @user = User.find params[:id]
    if @user.password_reset_token_expired?
      redirect_to root_path, notice: "Password reset has expired!"
    end
  end

  def update
    @user = User.find params[:id]
    user_params = params.permit(:password, :password_confirmation)
    if @user.update user_params
      @user.unlock_account
      redirect_to root_path, notice: "Password Successfully Reset!"
    else
      redirect_to edit_user_path(@user)
      flash[:alert] = "The new password does not match the password confirmation."
    end
  end


  def password_reset_token
    SecureRandom.urlsafe_base64
  end
end
