class RemoveProductFromCart
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call(client_id:, product_id:, quantity: nil, cart:)
    removed = cart.remove_item(product_id: product_id, quantity: quantity)
    raise ArgumentError, "Producto de ID #{product_id} não encontrado no carrinho." unless removed

    @cart_repository.save(cart)

    cart
  end
end
