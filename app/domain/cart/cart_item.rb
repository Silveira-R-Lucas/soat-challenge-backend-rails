class CartItem
  attr_accessor :id, :cart_id, :product_id, :product_name, :product_price, :quantity

  def initialize(attributes = {})
    @id = attributes[:id]
    @cart_id = attributes[:cart_id]
    @product_id = attributes[:product_id]
    @product_name = attributes[:product_name]
    @product_price = attributes[:product_price]
    @quantity = attributes[:quantity]
  end

  def total
    product_price * quantity
  end

  def to_h
    {
      id: id,
      product_id: product_id,
      product_name: product_name,
      product_price: product_price,
      quantity: quantity,
      total: total
    }
  end
end
