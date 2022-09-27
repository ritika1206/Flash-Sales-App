class PasswordsController < ApplicationController
  skip_before_action :authorize

  def forgot_password
    @user = User.new
  end

  def forgot_password_verify_email
    @user = User.find_by(email: permitted_params[:email])
    UserMailer.verify_email_for_forgot_password(@user).deliver_now
  end

  def edit_password
    @user = User.find_by(verification_token: params[:token])
  end

  def set_new_password
    user = User.find_by(id: params[:user_id])
    if user.present?
      user.update!(permitted_params)
      redirect_to deals_url
    else
      redirect_to user_email_url, notice: 'User does not exist'
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:email, :user_id, :password, :password_confirmation)
    end
end
