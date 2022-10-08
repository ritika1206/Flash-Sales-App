class OrdersController < ApplicationController
  def show
    @order = logged_in_user.orders.find_by(status: 'in_cart')
  end

  def create
    order = Order.find_or_initialize_by(status: 'in_cart', user_id: logged_in_user.id)
    deal = Deal.find(permitted_params[:deal_id])
    if order.save
      line_item = LineItem.find_or_initialize_by(deal_id: permitted_params[:deal_id], quantity: permitted_params[:quantity], order_id: order.id, discounted_price: deal.discount_price_in_cents)
      notice = ''
      if line_item.persisted?
        notice = 'Deal already exist in the buying list'
      else
        if (order.line_items << line_item).present?
          notice = t(:successfull, resource_name: 'added deal in the buying list')
        else
          notice = 'Cannot purchase the same deal more than once'
        end
      end
      redirect_to order_url(order.id), notice: notice
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
