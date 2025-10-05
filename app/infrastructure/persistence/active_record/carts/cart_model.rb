class CartModel < ApplicationRecord
  self.table_name = "cart_models"

  belongs_to :client_model, class_name: "ClientModel", optional: true
  has_many :cart_item_models, class_name: "CartItemModel", dependent: :destroy
  has_many :products, through: :orders
end
