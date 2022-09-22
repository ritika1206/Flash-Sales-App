class ApplicationController < ActionController::Base
  before_action :authorize

  private
    def authorize
      redirect_to login_url, notice: 'Please login to access the app' if cookies[:user_id].blank?
    end
end
