class Api::V1::DealsController < ApplicationController
  def index
    deals = Deal.where(status: params[:status])

    if deals.first.live? || deals.first.published?
      render json: deals, each_serializer: DealSerializer
    end
  end
end
