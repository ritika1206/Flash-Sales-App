class UsersController < ApplicationController
  skip_before_action :authorize, only: [:forgot_password, :forgot_password_mail_sent, :edit_password, :update]

  def index
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
      redirect_to login_url, notice: 'Something went wrong'
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token, :id)
    end
end
