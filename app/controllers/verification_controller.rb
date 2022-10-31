class VerificationController < ApplicationController
  skip_before_action :authorize, only: :verify
  
  def verify
    user = User.find_by(verification_token: params[:verification_token])
    if user.update(verified_at: Time.current)
      redirect_to login_url, notice: t(:successful, resource_name: 'verified, ') + t(:login_for_app_access)
    end
  end
end
