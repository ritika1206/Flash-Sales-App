class OrdersController < ApplicationController
  before_action :set_deal, only: :create
  before_action :set_order, only: :show
  before_action :set_order_for_cancel, only: :cancel

  def index
    @orders = logged_in_user.orders
  end

  def show
    @shipping_address = Address.find_by(id: @order.try(:shipping_address_id))
  end

  def create
    # This would avoid creating more than one order with status as in cart
    order = Order.find_or_initialize_by(status: :in_cart, user_id: logged_in_user.id)
    line_item = order.line_items.find_or_initialize_by(permitted_params.merge(discounted_price: @deal.discount_price_in_cents))

    # When order with status as In_cart already exists for the user
    if order.persisted?
      # Prevent adding a deal more than once in an order
      if line_item.persisted?
        redirect_to deals_url(status: 'live'), alert: t(:deal_already_present) + ' ' + t(:in_the_buying_list) and return
      else
        order.line_items << line_item
        redirect_to order_url(order), notice: t(:successful, resource_name: 'added deal') + ' ' + t(:in_the_buying_list)
      end
    #when order with status as In_cart does not exists for the user
    else
      # Prevent buying of a deal when it already exist exists in another order (preventing buying a same deal multiple times)
      if logged_in_user.line_items.exists?(deal_id: permitted_params[:deal_id])
        redirect_to deals_url(status: 'live'), alert: t(:not_allowed_to_buy_this_deal)
      else
        if order.save
          order.line_items << line_item
          redirect_to order_url(order), notice: t(:successful, resource_name: 'added deal') + ' ' + t(:in_the_buying_list)
        else
          redirect_to deals_url(status: 'live'), alert: t(:unable, resourec_name: 'create order')
        end
      end
    end
  end

  def cancel    
    if @order.update(status: 'cancelled')
      redirect_to order_url(@order), notice: t(:successful, resource_name: 'cancelled order')
    else
      redirect_to order_url(@order), alert: t(:default_error_message)
    end
  end

  def destroy
  end

  private

    def permitted_params
      params.require(:order).permit(:deal_id, :quantity)
    end

    def set_deal
      @deal = Deal.find_by(id: permitted_params[:deal_id])
      redirect_to deals_url(status: 'live'), alert: t(:inexistent, resource_name: 'Deal') if @deal.blank?
    end

    def set_order
      @order = Order.find_by(id: params[:id])
    end

    def set_order_for_cancel
      order = Order.find_by(id: params[:order_id])
    end
end
