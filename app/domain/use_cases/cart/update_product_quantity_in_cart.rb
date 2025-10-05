class UpdateProductQuantityInCart
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call(client_id:, product_id:, new_quantity:, cart:)
    raise ArgumentError, "Quantidade deve ser um número não negativo." unless new_quantity.is_a?(Integer) && new_quantity >= 0

    updated = cart.update_item_quantity(product_id: product_id, new_quantity: new_quantity)
    raise ArgumentError, "Produto de ID #{product_id} não encontrado no carrinho." unless updated
    @cart_repository.save(cart)

    cart
  end
end
