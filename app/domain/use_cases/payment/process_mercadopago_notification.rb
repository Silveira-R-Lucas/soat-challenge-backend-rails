class ProcessMercadopagoNotification
  def initialize(mercadopago_webhook_adapter:, cart_repository:)
    @mercadopago_webhook_adapter = mercadopago_webhook_adapter
    @cart_repository = cart_repository
  end

  def call(params:, headers:)
    payment_id = @mercadopago_webhook_adapter.parse_notification(params, headers)
    return false unless payment_id

    payment_details_result = @mercadopago_webhook_adapter.get_payment_details(payment_id)

    unless payment_details_result[:successful]
      Rails.logger.error "Falha ao pegar detalhes do pagamento pela API do Mercado Pago: #{payment_details_result[:error]}"
      return false
    end

    full_payment_data = payment_details_result[:details]

    notification = PaymentNotification.new(
      id: full_payment_data[:id],
      status: full_payment_data[:status],
      amount: full_payment_data[:transaction_amount] || 0.0,
      external_reference: full_payment_data[:external_reference],
      payment_method: full_payment_data[:payment_method_id]
    )

    cart = @cart_repository.find(notification.external_reference)

    unless cart
      Rails.logger.warn "Carrinho com ID #{notification.external_reference} não encontrado para a notificação do Mercado Pago."
      return false
    end

    if notification.amount != cart.total_amount
      Rails.logger.error "Valor do pagamento #{notification.amount} diferente do total do pedido #{cart.total_amount}, pedido: #{cart.id}."
      return false
    end

    if notification.approved?
      cart.mark_as_paid
      @cart_repository.save(cart)
      true
    else
      cart.update_status_based_on_payment_notification(notification.status)
      @cart_repository.save(cart)
      false
    end
  rescue StandardError => e
    Rails.logger.error "Erro ao processar notificação do Mercado Pago: #{e.message}"
    false
  end
end
