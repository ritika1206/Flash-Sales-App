class Admin::DealsController < Admin::BaseController
  def index
    @deals = Deal.all
  end

  def new
    @deal = Deal.new
  end

  def create
    p params
    p deal_permitted_params
    deal = Deal.new(deal_permitted_params)
    deal.images.attach params[:deal][:images]

    if deal.save!
      redirect_to admin_deals_url
    else
      redirect_to new_admin_deal_url, notice: 'Something went wrong'
    end
  end

  private
    def deal_permitted_params
      params.require(:deal).permit(:title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :published_at)
    end
end
