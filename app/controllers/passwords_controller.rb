class PasswordsController < ApplicationController
  skip_before_action :authorize

  def new
    @user = User.new
  end

  def forgot_password_verify_email
    @user = User.find_by(email: permitted_params[:email])
    if @user.present?
      UserMailer.verify_email_for_forgot_password(@user).deliver_now
      render 'email_confirmation'
    else
      permitted_params[:email].blank? ? (flash[:alert] = 'Please provide an email') : flash[:alert] = 'Email does not exist'
      redirect_to new_password_url
    end
  end

  def edit
    @user = User.find_by(verification_token: params[:token])
  end

  def update
    @user = User.find_by(verification_token: params[:verification_token])
    if @user.update(permitted_params)
      if permitted_params[:password].blank? || permitted_params[:password_confirmation].blank?
        redirect_to edit_password_url(token: @user.verification_token), alert: 'Both the fields are required'
      else
        redirect_to deals_url(status: 'live'), notice: t(:successful, resource_name: 'set new password')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:email, :user_id, :password, :password_confirmation)
    end
end
