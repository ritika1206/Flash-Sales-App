class DealsController < ApplicationController
  before_action :set_deal, only: :show

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
    respond_to do |format|
      format.json { render json: @deal }
      format.html
    end
  end

  private

    def set_deal
      @deal = Deal.includes(images_attachments: [:blob]).find(params[:id])
      redirect_to deals_url, alert: t(:inexistent, resource_name: 'Deal') if @deal.blank?
    end
end
