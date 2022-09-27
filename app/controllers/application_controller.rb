class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authorize
  before_action :restrict_access_to_admin_only

  private
    def authorize
      redirect_to login_url, notice: t(:login_for_app_access) unless user_logged_in?
    end

    def restrict_access_to_admin_only
      if user_logged_in?
        redirect_to live_admin_deals_url, notice: t(:access_prohibitted) unless admin_logged_in?
      end
    end
end
