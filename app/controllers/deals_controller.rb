class DealsController < ApplicationController
  def index
    @deals = Deal.live_deals
  end

  def show
    @deal = Deal.find(params[:id])
  end
end
