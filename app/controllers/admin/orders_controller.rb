class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.all
    @orders = User.find_by(email: params[:email]).orders if params[:email].present?
    @users = User.all
  end

  def mark_status
    order_transaction = OrderTransaction.find_by(order_id: params[:order_id])
    order = Order.find(params[:order_id])
    if order_transaction.status == 'paid'
      if permitted_params[:status] == 'Cancelled'
        Stripe::Refund.create({payment_intent: order_transaction.payment_intent_id, amount: order_transaction.amount.to_i})
        ActiveRecord::Base.transaction do
          order_transaction.update(status: 'refunded')
          order.update(status: permitted_params[:status].parameterize(separator: '_'))
        end
      elsif permitted_params[:status] == 'In Cart'
        redirect_to order_url(id: params[:order_id]), notice: 'Update not allowed'
      else
        order.update(status: permitted_params[:status].parameterize(separator: '_'))
      end
      redirect_to order_url(id: params[:order_id]), notice: t(:successfull, resource_name: 'updated order status')
    else
      redirect_to order_url(id: params[:order_id]), notice: 'Update not allowed'
    end
  end

  private

    def permitted_params
      params.require(:order).permit(:status)
    end
end
