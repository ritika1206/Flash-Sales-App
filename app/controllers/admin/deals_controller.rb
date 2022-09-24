class Admin::DealsController < Admin::BaseController
  def index
    @deals = Deal.all
  end

  def published
    @deals = Deal.where(published: true )
  end

  def unpublished
    p @deals = Deal.where(published: false)
    render :index
  end

  def new
    @deal = Deal.new
  end

  def create
    deal = Deal.new(deal_permitted_params)
    deal.images.attach params[:deal][:images]

    if deal.save!
      redirect_to admin_deals_url
    else
      redirect_to new_admin_deal_url, notice: 'Something went wrong'
    end
  end

  def show
    @deal = Deal.find_by(id: params[:id])
  end

  def edit
    @deal = Deal.find_by(id: params[:id])
    render :new
  end

  def destroy
    deal = Deal.find_by(id: params[:id])
    deal.images.purge
    deal.destroy!
    redirect_to unpublished_admin_deals_url, notice: "Deal destroyed successfully"
  end

  private
    def deal_permitted_params
      params.require(:deal).permit(:title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :published_at)
    end
end
