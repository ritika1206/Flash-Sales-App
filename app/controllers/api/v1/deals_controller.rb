class Api::V1::DealsController < ApplicationController
  skip_before_action :authorize
  before_action :api_authorize

  def index
    deals = Deal.where(status: params[:status])

    unless params[:status] == 'unpublished'
      render json: deals, each_serializer: DealSerializer
    else
      render json: []
    end
  end
end
