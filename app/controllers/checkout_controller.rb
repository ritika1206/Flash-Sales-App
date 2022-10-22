class CheckoutController < ApplicationController
  before_action :set_transaction, only: %i(success cancel)
  before_action :set_order, only: :checkout

  def checkout
    line_items = []

    @order.line_items.each do |line_item|
      line_items << {
        price: Stripe::Price.create({
          unit_amount: line_item.net_price_after_tax.round,
          currency: 'usd',
          product: Stripe::Product.create({ name: line_item.deal.title }).id,
        }).id,
        quantity: 1
      }
    end

    session = Stripe::Checkout::Session.create({
      line_items: line_items,
      mode: 'payment',
      billing_address_collection: "auto",
      success_url: CGI.unescape(success_url(checkout_session_id: '{CHECKOUT_SESSION_ID}', order_id: @order.id)),
      cancel_url: CGI.unescape(cancel_url(checkout_session_id: '{CHECKOUT_SESSION_ID}', order_id: @order.id))
    })
    redirect_to session.url, allow_other_host: true
  end

  def success
    @css_class = ''
    if @transaction.save
      if @order.update(placed_at: Time.current, status: :placed)
        @notice = t(:successful, resource_name: 'placed order')
        @css_class = 'notice'
      else
        @notice = t(:unable, resourec_name: 'update order')
        @css_class = 'alert'
      end
    else
      @notice = t(:default_error_message)
      @css_class = 'alert'
    end
  end

  def cancel
    @transaction.save
  end

  private
     
    def set_transaction
      transaction = Stripe::Checkout::Session.retrieve({
        id: params[:checkout_session_id],
        expand: ['payment_intent']
      })

      payment_intent = transaction.payment_intent

      @order = Order.find(params[:order_id])
      
      if payment_intent
        payment_error = payment_intent.last_payment_error
        @address = Address.find(@order.shipping_address_id)

        @transaction = OrderTransaction.new(
          order_id: params[:order_id],
          transaction_id: transaction.id,
          payment_intent_id: payment_intent.id,
          amount: transaction.amount_subtotal,
          status: transaction.payment_status,
          code: payment_error.try(:decline_code),
          reason: payment_error.try(:message),
          payment_mode: payment_intent.payment_method_types.first,
          address: @address
        )
      else
        @transaction = OrderTransaction.new(
          order_id: params[:order_id],
          transaction_id: transaction.id,
          status: 'unpaid',
        )        
      end
    end

    def set_order
      @order = Order.find_by(id: params[:id])
    end
end
