class RegistrationController < ApplicationController
  skip_before_action :authorize
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)

    if @user.save
      redirect_to login_url, alert: t(:verify_email)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token, :id)
    end 
end
