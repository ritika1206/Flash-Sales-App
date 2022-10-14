class Admin::DealsController < Admin::BaseController
  before_action :requested_deal, only: [:show, :edit, :destroy, :update]
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
    @deal.admin = logged_in_user
    @deal.current_quantity = deal_permitted_params[:initial_quantity]

    if @deal.save
      redirect_to admin_deals_url(status: 'unpublished')
    else
      redirect_to new_admin_deal_url, notice: t(:default_error_message)
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
      redirect_to admin_deal_url(@deal), notice: t(:successfull, resource_name: 'updated deal')
    else
      redirect_to admin_deals_url(status: 'unpublished'), notice: t(:default_error_message)
    end
  end

  def destroy
    if @deal.destroy
      redirect_to admin_deals_url(status: 'unpublished'), notice: t(:successfull, resource_name: 'destroyed deal')
    else
      redirect_to admin_deal_url(@deal), notice: t(:default_error_message)
    end
  end

  private

    def deal_permitted_params
      params.require(:deal).permit(:title, :description, :price_in_cents, :discount_price_in_cents, :initial_quantity, :tax_percentage, :published_at)
    end

    def requested_deal
      @deal = Deal.find(params[:id])
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
