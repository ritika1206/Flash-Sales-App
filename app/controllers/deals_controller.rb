class DealsController < ApplicationController
  def index
    @live_deals = Deal.live_deals
  end

  def show
    @live_deal = Deal.find(params[:id])
  end
end
