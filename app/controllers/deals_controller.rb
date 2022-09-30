class DealsController < ApplicationController
  def index
    @deals = Deal.live_deals
    @deals = Deal.order(created_at: :desc).limit(2) if @deals.empty?
  end

  def show
    @deal = Deal.find(params[:id])
  end
end
