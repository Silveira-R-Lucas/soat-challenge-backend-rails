class DeleteProduct
  def initialize(product_repository:)
    @product_repository = product_repository
  end

  def call(id:)
    @product_repository.delete(id)
  end
end
