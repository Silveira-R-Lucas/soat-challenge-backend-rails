class UpdateCartStatus
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call(cart_id:, new_status:)
    cart = @cart_repository.find(cart_id)
    raise ArgumentError, "Cart with ID #{cart_id} not found." unless cart

    cart.update_status!(new_status)
    @cart_repository.save(cart)

    cart
  rescue ArgumentError => e
    raise e
  end
end
