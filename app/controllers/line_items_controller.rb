class LineItemsController < ApplicationController
  def destroy
    line_item = LineItem.find(params[:id])
    if line_item.order.line_items.destroy(line_item)
      notice = t(:successfull, resource_name: 'deleted deal from order')
    else
      notice = t(:default_error_message)
    end
    if admin_logged_in?
      redirect_to admin_orders_url, notice: notice
    else
      redirect_to order_url(line_item.order), notice: notice
    end
  end
end
