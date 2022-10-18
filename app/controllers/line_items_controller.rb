class LineItemsController < ApplicationController
  def destroy
    line_item = LineItem.find(params[:id])
    if line_item.order.line_items.destroy(line_item)
      flash[:notice] = t(:successful, resource_name: 'deleted deal from order')
    else
      flash[:alert] = t(:default_error_message)
    end
    redirect_to orders_url
  end
end
