class ApplicationController < ActionController::Base
  before_action :authorize

  private
    def authorize
      redirect_to login_url, notice: t(:login_for_app_access) if cookies[:user_id].blank?
    end
end
