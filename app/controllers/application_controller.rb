class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authorize

  private
  
    def authorize
      redirect_to login_url, alert: t(:login_for_app_access) unless user_logged_in?
    end

    def api_authorize
      @user = User.find_by(api_token: params[:api_token]).blank?
      render(json: { response_status: 401, message: 'Invalid token or unauthorized user' }) if @user.blank?
    end
end
