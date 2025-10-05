class ListInProgressCarts
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call
    in_progress_status = %w[ pronto em_preparação recebido]
    @cart_repository.find_by_status(in_progress_status)
  end
end
