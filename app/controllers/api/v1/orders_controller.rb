class Api::V1::OrdersController < ApplicationController
  skip_before_action :authorize
  before_action :api_authorize
  
  def index    
    orders = @user.orders
    render json: orders
  end
end
