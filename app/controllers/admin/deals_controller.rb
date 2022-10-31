class Admin::DealsController < Admin::BaseController
  before_action :set_deal, only: %i(show edit destroy update)
  before_action :destroy_images, only: :update
  before_action :set_price, only: :update
  before_action :set_images, only: :update
  
  def index
    @status = params[:status] || 'live'
    @deals = Deal.includes(images_attachments: [:blob]).where(status: @status)
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = logged_in_user.deals.build(deal_permitted_params)
    set_images
    set_price
    if @deal.save
      redirect_to admin_deals_url(status: 'unpublished'), notice: t(:successful, resource_name: 'created deal')
    else
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

    def set_deal
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

    def set_price
      @deal.price_in_cents = to_cent(params[:deal][:price_in_cents])
      @deal.discount_price_in_cents = to_cent(params[:deal][:discount_price_in_cents])
    end

    def set_images
      params[:deal][:images].each { |image| @deal.images.attach(image) }
    end
end
