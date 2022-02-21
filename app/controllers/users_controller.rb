class UsersController < ApplicationController
  skip_before_action :render_login, only: [:edit_password, :update_password]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit_password

  end

  def update_password
    @user = User.last

    if params[:new_password] == params[:confirm_password]
      @user.password = params[:new_password]
      @user.save!
    end

    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
