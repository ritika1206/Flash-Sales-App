class OrdersController < ApplicationController
  def index
    @orders = Order.where(user_id: logged_in_user.id)
  end

  def show
  end

  def create
    order = Order.new(status: 'in_cart', user_id: logged_in_user.id)
    p order
    if order.save!
      p LineItem.create(deal_id: permitted_params[:deal_id], quantity: permitted_params[:quantity], order_id: order.id)
      redirect_to orders_url, notice: t(:successfull, resource_name: 'added deal in the buying list')
    else
      redirect_to deal_url(id: permitted_params[:deal_id]), notice: t(:default_error_message)
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def permitted_params
      params.require(:order).permit(:deal_id, :quantity)
    end
end
