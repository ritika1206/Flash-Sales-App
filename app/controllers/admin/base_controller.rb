class Admin::BaseController < ApplicationController
  before_action :restrict_access_to_admin_only

  private 

    def restrict_access_to_admin_only
      if user_logged_in?
        @status = 'live'
        redirect_to deals_url(status: 'live'), alert: t(:access_prohibitted) unless admin_logged_in?
      end
    end
end
