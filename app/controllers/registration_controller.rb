class RegistrationController < ApplicationController
  skip_before_action :authorize
  
  def new
    @user = User.new
  end

  def create
    user = User.new(permitted_params)

    if user.save
      redirect_to login_url, notice: 'Please verify your email to login'
    else
      redirect_to new_user_url, notice: 'Something went wrong'
    end
  end

  private
  def permitted_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token, :id)
  end 
end
