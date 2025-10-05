class ClientModel < ApplicationRecord
  self.table_name = "client_models"

  has_many :carts
  validates_presence_of :name, :email, :cpf
end
