class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.all
    @orders = User.find_by(email: params[:email]).orders if params[:email].present?
  end

  # def show
  #   @order = Order.find(params[:id])
  # end

  # def new
  # end

  # def create
  # end

  # def edit
  # end

  # def update
  # end

  # def destroy
  # end
end
