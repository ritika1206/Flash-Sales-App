class Admin::OrdersController < Admin::BaseController
  before_action :latest_order_transaction_for_order_in_params, only: :mark_status
  before_action :order_in_params, only: :mark_status

  def index
    @orders = Order.all
    @users = User.includes(:orders).all
    if params[:email].present?
      @users = [User.find_by(email: params[:email])]
      @orders = @users.first.try(:orders)
    end
  end

  def mark_status
    if @order_transaction.paid?
      if permitted_params[:status] == 'In Cart'
        redirect_to order_url(id: params[:order_id]), alert: t(:update_not_allowed)
      else
        if @order.update(status: permitted_params[:status].parameterize(separator: '_'))
          redirect_to order_url(id: params[:order_id]), notice: t(:successful, resource_name: 'updated order status')
        else
          redirect_to order_url(id: params[:order_id]), notice: t(:unable, resource_name: 'update status')
        end
      end
    else
      redirect_to order_url(id: params[:order_id]), alert: t(:update_not_allowed)
    end
  end

  private

    def permitted_params
      params.require(:order).permit(:status)
    end

    def latest_order_transaction_for_order_in_params
      @order_transaction = OrderTransaction.latest_transaction(params[:order_id])
      redirect_to admin_orders_url, alert: t(:transaction_inexistent) if @order_transaction.blank?
    end

    def order_in_params
      @order = Order.find_by(id: params[:order_id])
    end
end
