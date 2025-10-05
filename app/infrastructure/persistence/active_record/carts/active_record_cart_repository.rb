class ActiveRecordCartRepository
  include CartRepository

  def find_or_create_by_client_id(client_id, cart_id)
    if client_id.present? && cart_id.present?
      ar_cart = CartModel.includes(:cart_item_models).find_by(id: cart_id)
      ar_client = ClientModel.find_by(id: client_id)
      ar_cart.client_model_id = ar_client.id if ar_client
      ar_cart.save!
    else
      ar_cart = CartModel.includes(:cart_item_models).find_by(id: cart_id)
    end 

    unless ar_cart
      ar_client = ClientModel.find(client_id)
      ar_cart = CartModel.create!(client_model: ar_client)
    end

    map_ar_cart_to_domain(ar_cart)
  rescue ActiveRecord::RecordNotFound
    raise ArgumentError, "Cliente com ID #{client_id} não encontrado."
  end

  def create_anonymous_cart 
    ar_cart = CartModel.create!
    ar_cart.client_model_id = 99999
    ar_cart.save!
    map_ar_cart_to_domain(ar_cart)
  end

  def find(id)
    ar_cart = CartModel.includes(:cart_item_models).find_by(id: id)
    map_ar_cart_to_domain(ar_cart)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def save(cart)
    ar_cart = cart.id ? CartModel.find(cart.id) : CartModel.new
    ar_cart.client_model_id = cart.client_id
    ar_cart.total_price = cart.total_amount
    ar_cart.payment_status = cart.payment_status
    ar_cart.status = cart.status 
    ar_cart.save! 

    current_product_ids_in_domain = cart.items.map(&:product_id).compact
    ar_cart.cart_item_models.where.not(product_model_id: current_product_ids_in_domain).destroy_all

    cart.items.each do |item|
      ar_item = ar_cart.cart_item_models.find_by(product_model_id: item.product_id)
      
      if ar_item
        ar_item.quantity = item.quantity
      else 
        ar_item = ar_cart.cart_item_models.build(
          product_model_id: item.product_id,
          quantity: item.quantity,
          cart_model_id: cart.id
        )
      end
      ar_item.save!
      item.id = ar_item.id
      item.cart_id = ar_item.cart_model.id
    end

    cart.id = ar_cart.id
    cart 
  end

  def find_by_status(status)
    ar_carts = CartModel.includes(:cart_item_models).where(status: status)
    ar_carts.map { |ar_cart| map_ar_cart_to_domain(ar_cart) }
  end

  def find_all
    ar_carts = CartModel.includes(:cart_item_models).all
    ar_carts.map { |ar_cart| map_ar_cart_to_domain(ar_cart) }
  end

  private

  def map_ar_cart_to_domain(ar_cart)
    return nil unless ar_cart
    items = ar_cart.cart_item_models.map do |ar_item|
      CartItem.new(
        id: ar_item.id,
        cart_id: ar_item.cart_model_id,
        product_id: ar_item.product_model_id,
        product_name: ar_item.product_model.name,
        product_price: ar_item.product_model.price,
        quantity: ar_item.quantity
      )
    end
    Cart.new(
    id: ar_cart.id, 
    client_id: ar_cart.client_model_id, 
    items: items, 
    total_price: ar_cart.total_price,
    payment_status: ar_cart.payment_status,
    status: ar_cart.status, 
    created_at: ar_cart.created_at,
    updated_at: ar_cart.updated_at )
  end
end
