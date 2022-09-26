class UsersController < ApplicationController
  skip_before_action :authorize, only: [:create, :new, :verify, :forgot_password, :forgot_password_mail_sent, :edit_password, :update]

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
    p user = User.find_by(verification_token: params[:verification_token])
    if user.present?
      user.update!(verified_at: Time.current)
      redirect_to login_url
    end
  end

  def edit
    @user = User.new
  end

  def forgot_password_mail_sent
    @user = User.find_by(email: permitted_params[:email])
    UserMailer.verify_email_for_forgot_password(@user).deliver_now
  end

  def edit_password
    @user = User.find_by(verification_token: params[:token])
  end

  def forgot_password
    @user = User.new
  end

  def update
    user = User.find_by(id: params[:id])
    if user.present?
      user.update!(password: permitted_params[:password], password_confirmation: permitted_params[:password_confirmation])
      redirect_to deals_url
    else
      redirect_to user_detail_users_url, notice: 'Something went wrong'
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token, :id)
    end
end
