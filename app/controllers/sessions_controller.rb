class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: permitted_params[:email])

    if user.try(:authenticate, permitted_params[:password])
      session[:user_id] = user.id
      redirect_to deals_path
    else
      redirect_to login_url, notice: "Invalid credentials"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end

  private
    def permitted_params
      params.require(:user).permit(:email, :password)
    end
end
