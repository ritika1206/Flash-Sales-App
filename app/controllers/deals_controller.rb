class DealsController < ApplicationController
  def index
    @status = params[:status] || 'live'
    @deals = Deal.where(status: @status)
    @deals = Deal.where(status: 'published').order(created_at: :desc).limit(2) if @deals.blank?
    respond_to do |format|
      format.json { render json: @deals }
      format.html
    end
  end

  def show
    @deal = Deal.find(params[:id])
    respond_to do |format|
      format.json { render json: @deal }
      format.html
    end
  end
end
