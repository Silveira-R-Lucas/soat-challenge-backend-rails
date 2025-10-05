class ListCheckedOutCarts
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call
    checked_out_status = %w[ recebido em_preparação pronto finalizado]
    @cart_repository.find_by_status(checked_out_status)
  end
end
