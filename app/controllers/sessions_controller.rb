class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: permitted_params[:email])
    cookie_expiration = 10.days.from_now if permitted_params[:remember_me] == '1'
    p permitted_params

    if user.try(:authenticate, permitted_params[:password])
      if user.verified_at.present?
        cookies.encrypted[:user_id] = {
          value: user.id,
          expires: cookie_expiration
        }
        redirect_to deals_path
      else
        redirect_to login_url, notice: 'Please verify your email to login'
      end
    else
      redirect_to login_url, notice: "Invalid credentials"
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to login_url
  end

  private
    def permitted_params
      params.require(:user).permit(:email, :password, :remember_me)
    end
end
