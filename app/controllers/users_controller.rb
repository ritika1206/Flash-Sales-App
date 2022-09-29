class UsersController < ApplicationController
  skip_before_action :authorize
  before_action :requested_user, only: [:edit, :show, :update, :destroy]

  def index
    @users = User.all
  end

  def edit
  end

  def show
  end

  def update
    if @user.present?
      user.update!(permitted_params)
      redirect_to users_url, notice: t(:successfull, resource_name: 'updated user')
    else
      redirect_to edit_user_url, notice: t(:default_error_message)
    end
  end

  def destroy
    if @user.destroy
      redirect_to sign_up_url, notice: t('successfull', resource_name: 'deleted user')
    else
      redirect_to user_url, notice: t(:default_error_message)
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token)
    end

    def requested_user
      @user = User.find(params[:id])
    end
end
