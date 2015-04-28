class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url, success: t("flash.login-success")
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, success: t("flash.logout-success")
  end

  def failure
    redirect_to root_url, error: t("flash.login-fail")
  end

end
