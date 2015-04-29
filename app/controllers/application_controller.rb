class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :success, :error
  before_filter :set_locale
  #before_filter :show_flash

  private
  def set_locale
    # Makro for transforming sth in double quotes into locale
    # f"vf"S(itllxf"lx2F"ci"

    I18n.locale = "nl"
  end
  def show_flash
    flash[:success] = "Success"
    flash[:error] = "Success"
    flash[:notice] = "Success"
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_user
    if !current_user
      redirect_to root_path, error: t("flash.require-login")
    end
  end
end

