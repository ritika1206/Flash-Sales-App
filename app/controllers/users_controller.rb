class UsersController < ApplicationController
  skip_before_action :authorize
  before_action :set_user, only: %i(edit show update destroy)
  before_action :restrict_other_user_profile_access, only: :show

  def edit
  end

  def show
    @orders = @user.orders
  end

  def update
    if @user.update(permitted_params)
      redirect_to user_url(params[:id]), notice: t(:successful, resource_name: 'updated user')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      if admin_logged_in?
        redirect_to admin_users_url, notice: t(:successful, resource_name: 'deleted user')
      else
        redirect_to sign_up_url, notice: t(:successful, resource_name: 'deleted user')
      end
    else
      redirect_to user_url, alert: t(:default_error_message)
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def restrict_other_user_profile_access
     redirect_to(user_url(logged_in_user), alert: t(:access_prohibitted)) if @user.id != logged_in_user.id && !admin_logged_in?
    end
end
