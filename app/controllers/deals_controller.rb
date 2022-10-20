class DealsController < ApplicationController
  def index
    @status = params[:status] || 'live'
    @deals = Deal.includes(images_attachments: [:blob]).where(status: @status)
    @deals = Deal.includes(images_attachments: [:blob]).where(status: 'published').order(created_at: :desc).limit(2) if @deals.blank?
    respond_to do |format|
      format.json { render json: @deals }
      format.html
    end
  end

  def show
    @deal = Deal.includes(images_attachments: [:blob]).find(params[:id])
    respond_to do |format|
      format.json { render json: @deal }
      format.html
    end
  end
end
