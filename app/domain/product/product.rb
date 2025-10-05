class Product
  attr_accessor :id, :name, :description, :category, :price, :quantity

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @description = attributes[:description]
    @category = attributes[:category]
    @price = attributes[:price]
    @quantity = attributes[:quantity]
  end

  def available?
    quantity > 0
  end
end
