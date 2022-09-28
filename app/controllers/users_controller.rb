class UsersController < ApplicationController
  skip_before_action :authorize, only: [:update]

  def index
    @users = User.all
  end

  def edit
    @user = User.new
  end

  def update
    user = User.find_by(id: permitted_params[:id])
    if user.present?
      user.update!(permitted_params)
      redirect_to deals_url
    else
      redirect_to login_url, notice: t(:default_error_message)
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token, :id)
    end
end
