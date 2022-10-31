class LineItemsController < ApplicationController
  before_action :set_line_item, only: :destroy

  def destroy
    if @line_item.destroy
      flash[:notice] = t(:successful, resource_name: t(:deleted_deal_from_order))
    else
      flash[:alert] = t(:default_error_message)
    end
    redirect_to orders_url
  end

  private

    def set_line_item
      @line_item = LineItem.find_by(id: params[:id])
    end
end
