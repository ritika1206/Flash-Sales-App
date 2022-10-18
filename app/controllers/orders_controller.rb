class OrdersController < ApplicationController
  before_action :deal_in_params, only: [:create]

  def index
    @orders = logged_in_user.orders
  end

  def show
    @order = Order.find(params[:id])
    @shipping_address = Address.find_by(id: @order.try(:shipping_address_id))
  end

  def create
    # This would avoid creating more than one order with status as in cart
    order = Order.find_or_initialize_by(status: :in_cart, user_id: logged_in_user.id)
    line_item = LineItem.find_or_initialize_by(deal_id: permitted_params[:deal_id], quantity: permitted_params[:quantity], order_id: order.id, discounted_price: @deal.discount_price_in_cents)

    # When order with status as In_cart already exists for the user
    if order.persisted?
      # Prevent adding a deal more than once in an order
      if line_item.persisted?
        redirect_to deals_url(status: 'live'), alert: 'Deal already present in the buying list' and return
      else
        order.line_items << line_item
        redirect_to order_url(order), notice: 'Successfully added deal in the buying list'
      end
    #when order with status as In_cart does not exists for the user
    else
      # Prevent buying of a deal when it already exist exists in another order (preventing buying a same deal multiple times)
      if logged_in_user.line_items.exists?(deal_id: permitted_params[:deal_id])
        redirect_to deals_url(status: 'live'), alert: 'Not allowed to buy this deal'
      else
        if order.save
          order.line_items << line_item
          redirect_to order_url(order), notice: 'Successfully added deal in the buying list'
        else
          redirect_to deals_url(status: 'live'), alert: 'Unable to create order'
        end
      end
    end
  end

  def edit
  end

  def update
  end

  def cancel
    order = Order.find(params[:order_id])
    
    if order.update(status: 'cancelled')
      redirect_to order_url(order), notice: 'Successfully cancelled order'
    else
      redirect_to order_url(order), alert: t(:default_error_message)
    end
  end

  def destroy
  end

  private

    def permitted_params
      params.require(:order).permit(:deal_id, :quantity)
    end

    def deal_in_params
      @deal = Deal.find(permitted_params[:deal_id])
      redirect_to deals_url(status: 'live'), alert: 'Deal does not exist' if @deal.blank?
    end
end
