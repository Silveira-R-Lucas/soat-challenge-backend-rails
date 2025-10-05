class UpdateProduct
  def initialize(product_repository:)
    @product_repository = product_repository
  end

  def call(id:, attributes:)
    product = @product_repository.find(id)
    return nil unless product

    product.name = attributes[:name] if attributes.key?(:name)
    product.category = attributes[:category] if attributes.key?(:category)
    product.description = attributes[:description] if attributes.key?(:description)
    product.price = attributes[:price] if attributes.key?(:price)
    product.quantity = attributes[:quantity] if attributes.key?(:quantity)
    @product_repository.save(product)

    product
  end
end
