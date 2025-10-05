class CreateProduct
  def initialize(product_repository:)
    @product_repository = product_repository
  end

  def call(params)
    product = Product.new(params)
    @product_repository.save(product)
    product
  end
end
