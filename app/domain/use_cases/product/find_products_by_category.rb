class FindProductsByCategory
  def initialize(product_repository:)
    @product_repository = product_repository
  end

  def call(category_name:)
    @product_repository.find_by_category(category_name)
  end
end
