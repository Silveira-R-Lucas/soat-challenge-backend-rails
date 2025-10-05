class AddProductToCart
  def initialize(cart_repository:, product_repository:)
    @cart_repository = cart_repository
    @product_repository = product_repository
  end

  def call(client_id:, product_id:, quantity: 1, cart:)
    raise ArgumentError, "Quantidade precisa ser maior que 0." unless quantity.to_i > 0

    product = @product_repository.find(product_id)
    raise ArgumentError, "Produto não encontrado." unless product

    unless cart
      cart = Cart.new(client_id: client_id, cart_total_price: 0)
    end

    cart.add_item(product: product, quantity: quantity)
    @cart_repository.save(cart)

    cart
  end
end
