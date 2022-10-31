class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)
    set_verified_at
    if @user.save
      redirect_to admin_users_url, notice: t(:successful, resource_name: 'created user')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private 

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_token, :id)
    end

    def set_verified_at
      @user.verified_at = Time.current
    end
end
