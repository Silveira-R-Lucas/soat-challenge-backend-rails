class ActiveRecordProductRepository
  include ProductRepository
  def save(product)
    ar_product = product.id ? ProductModel.find(product.id) : ProductModel.new
    ar_product.name = product.name
    ar_product.category = product.category
    ar_product.description = product.description
    ar_product.price = product.price
    ar_product.quantity = product.quantity
    ar_product.save!

    product.id = ar_product.id
    product
  end

  def find(id)
    ar_product = ProductModel.find(id)
    Product.new(id: ar_product.id, name: ar_product.name, category: ar_product.category, description: ar_product.description, price: ar_product.price, quantity: ar_product.quantity)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def find_by_category(category_name)
    ar_products = ProductModel.where(category: category_name)

    ar_products.map do |ar_product|
      Product.new(
        id: ar_product.id,
        name: ar_product.name,
        description: ar_product.description,
        price: ar_product.price,
        quantity: ar_product.quantity,
        category: ar_product.category
      )
    end
  end

  def find_all
    ProductModel.all.map do |ar_product|
      Product.new(id: ar_product.id, name: ar_product.name, category: ar_product.category, description: ar_product.description, price: ar_product.price, quantity: ar_product.quantity)
    end
  end

  def delete(id)
    product_model = ProductModel.find(id)
    product_model.destroy!
    true
  rescue ActiveRecord::RecordNotFound
    false
  end
end
