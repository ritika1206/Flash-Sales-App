class Api::V1::OrdersController < ApplicationController
  skip_before_action :authorize
  
  def index
    user = User.find_by(api_token: params[:api_token])
    
    if user.present?
      orders = user.orders
      render json: orders
    else
      render json: { response_status: 401, message: 'Invalid token or unauthorized user' }
    end
  end
end
