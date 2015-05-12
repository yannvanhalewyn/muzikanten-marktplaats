class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :success, :error
  before_filter :set_locale
  #before_filter :show_flash
  include ApplicationHelper
  helper_method :current_user

  private
  def set_locale
    I18n.locale = "fr"
  end

  def show_flash
    flash[:success] = "Success"
    flash[:error] = "Success"
    flash[:notice] = "Success"
  end

  def require_user
    if !current_user
      redirect_to root_path, error: t("flash.require-login")
    end
  end
end

