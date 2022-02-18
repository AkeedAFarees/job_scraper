class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  before_action :render_login, unless: :logged_in?

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    !!session[:user_id]
  end

  def render_login
    render 'sessions/login'
  end
end