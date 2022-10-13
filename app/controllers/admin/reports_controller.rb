class Admin::ReportsController < Admin::BaseController
  def index
    @deals_revenue = Deal.deals_revenue

    @maximum_potential_deal = @deals_revenue.first
    @minimum_potential_deal = @deals_revenue.last

    if params[:to].present? || params[:from].present?
      p @customers_expenditure = User.customer_expenditure(params[:from].to_date, params[:to].to_date + 1)
    else
      @default_start_date = FlashSales::Reports::DEFAULT_CUSTOMER_EXPENDITIURE_START_DATE
      @customers_expenditure = User.customer_expenditure(@default_start_date, Date.today + 1)
    end
  end
end
