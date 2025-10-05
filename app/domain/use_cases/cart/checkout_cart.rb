class CheckoutCart
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call(cart:)
    cart.mark_as_received!
    @cart_repository.save(cart)

    cart
  rescue ArgumentError => e
    raise e
  end
end
