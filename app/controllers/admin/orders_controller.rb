class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.all
    @orders = User.find_by(email: params[:email]).orders if params[:email].present?
    @users = User.all
  end
end
