class UsersController < ApplicationController
  def index
  end

  def create
    user = User.new(permitted_params)

    if user.save
      redirect_to login_url, notice: 'Please verify your email to login'
    else
      redirect_to new_user_url, notice: 'Something went wrong'
    end
  end

  def new
    @user = User.new
  end

  def verify
    user = User.find_by(verification_token: params[:verification_token])
    if user.present?
      user.update!(verified_at: Time.current)
      redirect_to login_url
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
