class Admin::OrdersController < Admin::BaseController
  before_action :order_transaction_for_order_in_params

  def index
    @orders = Order.all
    @users = User.all
    if params[:email].present?
      @users = [User.find_by(email: params[:email])]
      @orders = @users.first.try(:orders)
    end
  end

  def mark_status
    @order_transaction = OrderTransaction.find_by(order_id: params[:order_id])
    order = Order.find(params[:order_id])

    if @order_transaction.paid?
      if permitted_params[:status] == 'In Cart'
        redirect_to order_url(id: params[:order_id]), alert: 'Update not allowed'
      else
        if order.update(status: permitted_params[:status].parameterize(separator: '_'))
          redirect_to order_url(id: params[:order_id]), notice: t(:successful, resource_name: 'updated order status')
        else
          redirect_to order_url(id: params[:order_id]), notice: 'Unable to update status'
        end
      end
    else
      redirect_to order_url(id: params[:order_id]), alert: 'Update not allowed'
    end
  end

  private

    def permitted_params
      params.require(:order).permit(:status)
    end

    def order_transaction_for_order_in_params
      @order_transaction = OrderTransaction.find_by(order_id: params[:order_id])
      redirect_to admin_orders_url, alert: 'No transaction exist for the order' if @order_transaction.blank?
    end
end
