class GetOrCreateClientCart
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call(client_id:, cart_id:)
    if client_id.present?
      @cart_repository.find_or_create_by_client_id(client_id, cart_id)
    else
      @cart_repository.create_anonymous_cart
    end
  rescue ArgumentError => e
    raise e
  end
end
