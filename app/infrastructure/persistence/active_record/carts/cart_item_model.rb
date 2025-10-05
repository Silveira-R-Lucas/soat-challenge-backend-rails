class CartItemModel < ApplicationRecord
  self.table_name = "cart_item_models"

  belongs_to :cart_model, class_name: "CartModel"
  belongs_to :product_model, class_name: "ProductModel"

  validates_numericality_of :quantity, greater_than_or_equal_to: 0
end
