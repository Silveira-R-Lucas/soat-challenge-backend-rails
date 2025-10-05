# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

5.times do
  ProductModel.create(
    name: Faker::Dessert.variety,
    category: 'Sobremesa',
    description: Faker::Dessert.flavor,
    quantity: 120,
    price: Faker::Commerce.price.to_f)
end

7.times do
  ProductModel.create(
    name: Faker::Food.dish,
    category: 'Acompanhamentos',
    description: Faker::Food.description,
    quantity: 120,
    price: Faker::Commerce.price.to_f)
end

12.times do
  ProductModel.create(
    name: Faker::Food.dish,
    category: 'Lanches',
    description: Faker::Food.description,
    quantity: 120,
    price: Faker::Commerce.price.to_f)
end

ProductModel.create([
  {
    name: 'Refrigerante',
    category: 'Bebidas',
    description: 'Coca-cola',
    quantity: 200,
    price: 9.99
  },
  {
    name: 'Suco',
    category: 'Bebidas',
    description: 'suco natural de laranja',
    quantity: 200,
    price: 6.99
  },
  {
    name: 'Milk-shake',
    category: 'Bebidas',
    description: 'milk shake de morango',
    quantity: 200,
    price: 19.99
  }
])

ClientModel.create(
    id: 99999,
    name: 'Anônimo',
    email: Faker::Internet.email,
    cpf: Faker::Number.leading_zero_number(digits: 11).to_s
  )

25.times do
  ClientModel.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    cpf: Faker::Number.leading_zero_number(digits: 11).to_s
  )
end

client_ids = ClientModel.all.pluck(:id)
products_ids = ProductModel.all.pluck(:id)
3.times do
  cart = CartModel.create(
  total_price: 0,
  status: 'pronto',
  payment_status: 'aprovado',
  client_model_id: client_ids.pop
  )
  Faker::Number.between(from: 1, to: 3).times do
    CartItemModel.create(product_model_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_model_id: cart.id)
  end
end

3.times do
  cart = CartModel.create(
  total_price: 0,
  status: 'finalizado',
  payment_status: 'aprovado',
  client_model_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    CartItemModel.create(product_model_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_model_id: cart.id)
  end
end


3.times do
  cart = CartModel.create(
  total_price: 0,
  status: 'em_preparação',
  payment_status: 'aprovado',
  client_model_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    CartItemModel.create(product_model_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_model_id: cart.id)
  end
end

3.times do
  cart = CartModel.create(
  total_price: 0,
  status: 'Recebido',
  payment_status: 'aprovado',
  client_model_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    CartItemModel.create(product_model_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_model_id: cart.id)
  end
end
