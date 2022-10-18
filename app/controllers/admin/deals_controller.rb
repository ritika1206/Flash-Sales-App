class Admin::DealsController < Admin::BaseController
  before_action :deal_in_params, only: [:show, :edit, :destroy, :update]
  before_action :destroy_images, only: :update
  before_action :set_images, only: :update
  
  def index
    @deals = Deal.where(status: params[:status])
    @status = params[:status]
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(deal_permitted_params)
    set_images
    @deal.created_by = logged_in_user
    @deal.current_quantity = deal_permitted_params[:initial_quantity]

    if @deal.save
      redirect_to admin_deals_url(status: 'unpublished'), notice: t(:successful, resource_name: 'created deal')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    render template: 'admin/deals/show'
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
      redirect_to admin_deals_url(status: 'live'), alert: 'Unable to delete deal'
    end
  end

  private

    def deal_permitted_params
      params.require(:deal).permit(:title, :description, :price_in_cents, :discount_price_in_cents, :initial_quantity, :tax_percentage, :published_at)
    end

    def deal_in_params
      @deal = Deal.find_by(params[:id])
      redirect_to admin_deals_url(status: 'live'), alert: 'Unable to find deal' if @deal.blank?
    end

    def set_images
      if params[:deal][:images].present?
        params[:deal][:images].each { |image| @deal.images.attach(image) }
      end
    end

    def destroy_images
      if params[:image_form].present?
        params[:image_form][:images_to_be_deleted].from(1).each do |image_id|
          @deal.images.destroy(image_id)
        end
      end
    end
end
