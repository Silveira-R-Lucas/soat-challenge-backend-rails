class FindProductById
  def initialize(product_repository:)
    @product_repository = product_repository
  end

  def call(id:)
    @product_repository.find(id)
  end
end
