module MercadoPago
  class PaymentGatewayAdapter
    require "curb"

    def initialize
      @token = ENV.fetch("MERCADOPAGO_TOKEN")
      @user_id = ENV.fetch("MERCADOPAGO_USER_ID")
      @external_pos_id = ENV.fetch("MERCADOPAGO_EXTERNAL_POS_ID")
      @notification_url = "#{ENV.fetch('MERCADOPAGO_NOTIFICATION_URL')}/api/v1/payment_notification"
    end

    def generate_qr_payment(cart_domain_object)
      params = {
        external_reference: cart_domain_object.id.to_s,
        title: "SOAT lanches",
        notification_url: @notification_url,
        description: "SOAT lanches",
        total_amount: cart_domain_object.total_price.to_f,
        items: cart_domain_object.items.map do |item|
          {
            title: item.product_name,
            description: ProductModel.find_by(id: item.product_id)&.description,
            quantity: item&.quantity,
            unit_measure: "unit",
            unit_price: item&.product_price,
            total_amount: (item&.product_price * item&.quantity)
          }
        end
      }

      http = Curl.post("https://api.mercadopago.com/instore/orders/qr/seller/collectors/#{@user_id}/pos/#{@external_pos_id}/qrs", params.to_json) { |http|
        http.headers["Authorization"] = "Bearer #{@token}"
        http.headers["Content-Type"]="application/json"
      }

      body = JSON.parse(http.body)
      if http.code == 201
        { successful: true, status: http.code, response: body }
      else
        Rails.logger.error "Mercado Pago API error: #{e.message}"
        { successful: false, status: http.code, error: body }
      end
    end
  end
end
