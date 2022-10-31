class PasswordsController < ApplicationController
  skip_before_action :authorize

  def new
    @user = User.new
  end

  def forgot_password_verify_email
    @user = User.find_by(email: permitted_params[:email])
    if @user.present?
      UserMailer.verify_email_for_forgot_password(@user).deliver_later
      render 'email_confirmation'
    else
      permitted_params[:email].blank? ? (flash[:alert] = t(:please_provide_an_email)) : flash[:alert] = t(:inexistent, resource_name: 'Email')
      redirect_to new_password_url
    end
  end

  def edit
    @user = User.find_by(verification_token: params[:token])
  end

  def update
    @user = User.find_by(verification_token: params[:verification_token])
    @user.password_changing = params[:user][:password_changing]

    if @user.update(permitted_params)
      redirect_to deals_url(status: 'live'), notice: t(:successful, resource_name: 'set new password')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:email, :user_id, :password, :password_confirmation)
    end
end
