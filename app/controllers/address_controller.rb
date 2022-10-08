class AddressController < ApplicationController
  def create
    user = User.find_by(verification_token: params[:verification_token])

    address = user.addresses.build(permitted_address_params)
    if address.save
      redirect_to order_url(logged_in_user.orders.find_by(status: 'in_cart'), notice: t(:successfull, resource_name: 'added shipping address for order')
    else
      redirect_to new_address_url, notice: t(:default_error_message)
    end
  end

  def new
    @address = Address.new
  end
end
