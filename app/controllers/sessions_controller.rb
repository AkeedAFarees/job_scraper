class SessionsController < ApplicationController
  skip_before_action :render_login, only: :create

  def create
    @user = User.find_by(username: params[:username])

    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to records_path
    else
      message = "Something went wrong! Make sure your username and password are correct"
      redirect_to login_path, notice: message
    end
  end

  # Logs out the current user.
  def destroy
    session.delete(:user_id)
    @current_user = nil

    redirect_to login_path
  end
end