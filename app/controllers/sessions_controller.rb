class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: permitted_params[:email])

    if user.try(:authenticate, permitted_params[:password])
      cookies.encrypted[:user_id] = {
        value: user.id,
        expires: 10.days.from_now
      }
      redirect_to deals_path
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
      params.require(:user).permit(:email, :password)
    end
end
