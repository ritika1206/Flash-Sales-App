class Admin::DealsController < Admin::BaseController
  before_action :deal_in_params, only: %i(show edit destroy update)
  before_action :destroy_images, only: :update
  before_action :initialize_deal, only: :create
  before_action :initialize_deal_for_update, only: :update
  before_action :set_price, only: %i(create update)
  before_action :set_images_on_create, only: :create
  before_action :set_images_on_update, only: :update
  
  def index
    @status = params[:status] || 'live'
    @deals = Deal.includes(images_attachments: [:blob]).where(status: @status)
  end

  def new
    @deal = Deal.new
  end

  def create
    if @deal.save
      redirect_to admin_deals_url(status: 'unpublished'), notice: t(:successful, resource_name: 'created deal')
    else
      debugger
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @images = @deal.images
  end

  def update
    if @deal.update(deal_permitted_params)
      redirect_to admin_deal_url(@deal), notice: t(:successful, resource_name: 'updated deal')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @deal.update(status: 'deleted')
      redirect_to admin_deals_url(status: 'deleted'), notice: t(:successful, resource_name: 'deleted deal')
    else
      redirect_to admin_deals_url(status: 'live'), alert: t(:unable, resource_name: 'delete deal')
    end
  end

  private

    def deal_permitted_params
      params.require(:deal).permit(:title, :description, :initial_quantity, :tax_percentage, :published_at)
    end

    def deal_in_params
      @deal = Deal.includes(images_attachments: [:blob]).find_by(id: params[:id])
      redirect_to admin_deals_url(status: 'live'), alert: t(:unable, resource_name: 'find deal') if @deal.blank?
    end

    def destroy_images
      if params[:image_form].present?
        params[:image_form][:images_to_be_deleted].from(1).each do |image_id|
          @deal.images.destroy(image_id)
        end
      end
    end

    def initialize_deal
      @deal = Deal.new(deal_permitted_params)
      @deal.creator = logged_in_user
      @deal.current_quantity = deal_permitted_params[:initial_quantity]
    end

    def set_images_on_create
      @deal.deal_images = params[:deal][:images]
    end

    def set_price
      @deal.price_in_cents = params[:deal][:price_in_cents].try(:to_f).try(:*, 100)
      @deal.discount_price_in_cents = params[:deal][:discount_price_in_cents].try(:to_f).try(:*, 100)
    end

    def initialize_deal_for_update
      @deal = Deal.find_by(id: params[:id])
    end

    def set_images_on_update
      params[:deal][:images].each { |image| @deal.images.attach(image) }
    end
end
