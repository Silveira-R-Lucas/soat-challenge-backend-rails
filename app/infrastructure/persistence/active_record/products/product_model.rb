class ProductModel < ApplicationRecord
  self.table_name = "product_models"

  has_many_attached :images
  validates_presence_of :name, :category, :price, :quantity
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
