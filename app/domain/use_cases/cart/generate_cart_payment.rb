class GenerateCartPayment
  def initialize(cart_repository:, payment_gateway_adapter:)
    @cart_repository = cart_repository
    @payment_gateway_adapter = payment_gateway_adapter
  end

  def call(cart:)
    raise ArgumentError, "Erro ao gerar pagamento, carrinho vazio." if cart.items.empty?
    raise ArgumentError, "Pagamento já foi gerado para este pedido (status: #{cart.payment_status})." unless cart.payment_status == "pendente"

    payment_result = @payment_gateway_adapter.generate_qr_payment(cart)
    unless payment_result[:successful]
      raise ArgumentError, "Payment gateway failed: #{payment_result[:error]}"
    end
    cart.update_payment_status!("aguardando_pagamento")
    @cart_repository.save(cart)
    {
      successful: true,
      cart: cart,
      payment_details: {
        payment_id: payment_result[:response]["in_store_order_id"],
        qr_data: payment_result[:response]["qr_data"]
      }
    }
  rescue ArgumentError => e
    raise e
  end
end
