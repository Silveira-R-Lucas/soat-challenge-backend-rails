class Cart
  attr_accessor :id, :client_id, :items, :payment_status, :status, :total_price, :created_at, :updated_at

  VALID_STATUS = %w[ novo recebido em_preparação pronto finalizado].freeze
  PAYMENT_STATUS = %w[ pendente aprovado autorizado aguardando_pagamento rejeitado cancelado].freeze
  IN_PROGRESS_STATUS = %w[ pronto em_preparação recebido].freeze

  def initialize(attributes = {})
    @id = attributes[:id]
    @client_id = attributes[:client_id]
    @payment_status = attributes[:payment_status] || 'pendente' 
    @status = attributes[:status] || 'novo'
    @items = attributes[:items] || []
    @total_price = self.total_amount
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end

  def update_status!(new_status)
    unless VALID_STATUS.include?(new_status)
      raise ArgumentError, "Status inválido: #{new_status}. Statuses válidos são: #{VALID_STATUS.join(', ')}."
    end

    raise ArgumentError, "Não é possível mudar pedido 'finalizado'." if status == 'finalizado'
    self.status = new_status
  end

  def payment_approved_or_authorized?
    payment_status == "aprovado" || payment_status == "autorizado"
  end

  def mark_as_received!
    raise ArgumentError, "Carrinho vazio, não é possível atualizar status para 'recebido'." if empty?
    raise ArgumentError, "Pagamento pendente ou não autorizado, não é possível atualizar status para 'recebido'" unless payment_approved_or_authorized?

    self.status = 'recebido'
  end

  def update_status_based_on_payment_notification(status)
    self.payment_status = status
  end

  def mark_as_paid
    self.payment_status = 'aprovado'
  end

  def empty?
    items.empty?
  end

  def update_payment_status!(new_status)
    self.payment_status = new_status
  end

  def add_item(product:, quantity: 1)
    existing_item = @items.find { |item| item.product_id == product.id }

    if existing_item
      existing_item.quantity += quantity
    else
      @items << CartItem.new(
        product_id: product.id,
        product_name: product.name,
        product_price: product.price,
        quantity: quantity
      )
    end
    self
  end

  def remove_item(product_id:, quantity: nil)
    item_to_remove = @items.find { |item| item.product_id == product_id }
    return false unless item_to_remove 

    if quantity.nil? || quantity >= item_to_remove.quantity
      @items.delete(item_to_remove)
    else
      item_to_remove.quantity -= quantity
    end
    true
  end

  def update_item_quantity(product_id:, new_quantity:)
    item_to_update = @items.find { |item| item.product_id == product_id }

    return false unless item_to_update 

    if new_quantity <= 0
      remove_item(product_id: product_id)
    else
      item_to_update.quantity = new_quantity
    end
    true
  end


  def total_amount
    @items.sum { |item| item.product_price * item.quantity }.to_f
  end

  def persisted?
    !id.nil?
  end

  def to_h_for_display
    {
      id: id,
      client_id: client_id,
      cart_total_price: total_amount,
      status: status,
      payment_status: payment_status,
      items: items.map do |item|
        {
          id: item.product_id,
          name: item.product_name,
          quantity: item.quantity,
          unit_price: item.product_price.to_f,
          total_price: item.product_price.to_f * item.quantity
        }
      end
    }
  end

  def kitchen_display
    {
      id: id,
      client_id: client_id,
      status: status,
      created_at: created_at,
      updated_at: updated_at,
      items: items.map do |item|
        {
          id: item.product_id,
          name: item.product_name,
          quantity: item.quantity,
          unit_price: item.product_price.to_f,
          total_price: item.product_price.to_f * item.quantity
        }
      end
    }
  end
end
