# require 'swagger_helper'

# RSpec.describe 'api/v1/carts', type: :request do
#   path '/api/v1/cart/' do
#     post 'create_order' do
#       tags 'Order'
#       consumes 'application/json'
#       produces 'application/json'

#       parameter name: :cart,
#         in: :body,
#         description: 'find cart by id',
#         schema: {
#           type: :object,
#           properties: {
#             cart_id: { type: :integer },
#             quantity: { type: :integer },
#             product_id: { type: :integer }
#           },
#           required: %w[quantity product_id cart_id client_id]
#         }

#       response '200', 'successful' do
#         schema type: :object,
#               properties: {
#                 cart_id: { type: :integer },
#                 products:  { type: :array,
#                   items: { type: :object,
#                     properties: { product_id: { type: :integer },
#                                   quantity: { type: :integer },
#                                   unit_price: { type: :number },
#                                   total_price: { type: :number }
#                     }
#                   }
#                 },
#                 cart_total_price: { type: :number }
#               }
#         run_test!
#       end

#       response '422', 'unprocessable entity' do
#         run_test!
#       end
#     end

#     get 'show cart' do
#       tags 'Order'
#       consumes 'application/json'
#       produces 'application/json'

#       response '200', 'successful' do
#         schema type: :object,
#               properties: {
#                 cart_id: { type: :integer },
#                 products:  { type: :array,
#                   items: { type: :object,
#                     properties: { product_id: { type: :integer },
#                                   quantity: { type: :integer },
#                                   unit_price: { type: :number },
#                                   total_price: { type: :number }
#                     }
#                   }
#                 },
#                 cart_total_price: { type: :number }
#               }
#         run_test!
#       end

#       response '404', 'not found' do
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/cart/{cart_id}/update_item' do
#     post 'update_item_to_cart' do
#       tags 'Order'
#       consumes 'application/json'
#       produces 'application/json'

#       parameter name: :cart_id,
#         in: :path,
#         type: :integer,
#         required: true

#       parameter name: :product,
#         in: :body,
#         description: 'product parameters',
#         schema: {
#           type: :object,
#           properties: {
#             name: { type: :string },
#             quantity: { type: :integer }
#           },
#           required: %w[name quantity]
#         }

#       response '200', 'successful' do
#         schema type: :object,
#               properties: {
#                 cart_id: { type: :integer },
#                 products:  { type: :array,
#                   items: { type: :object,
#                     properties: { product_id: { type: :integer },
#                                   quantity: { type: :integer },
#                                   unit_price: { type: :number },
#                                   total_price: { type: :number }
#                     }
#                   }
#                 },
#                 cart_total_price: { type: :number }
#               }
#         run_test!
#       end

#       response '422', 'unprocessable entity' do
#         run_test!
#       end

#       response '404', 'not found' do
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/cart/{product_id}' do
#     delete 'delete product from cart' do
#       tags 'Order'
#       produces 'application/json'

#       parameter name: :product_id,
#         in: :path,
#         type: :integer,
#         required: true,
#         description: 'find product by id'

#       response '200', 'successful' do
#         schema type: :object,
#               properties: {
#                 cart_id: { type: :integer },
#                 products:  { type: :array,
#                   items: { type: :object,
#                     properties: { product_id: { type: :integer },
#                                   quantity: { type: :integer },
#                                   unit_price: { type: :number },
#                                   total_price: { type: :number }
#                     }
#                   }
#                 },
#                 cart_total_price: { type: :number }
#               }
#         run_test!
#       end

#       response '404', 'not found' do
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/cart/{cart_id}/checkout' do
#     post 'checkout order' do
#       tags 'Order'
#       produces 'application/json'

#       parameter name: :cart_id,
#         in: :path,
#         type: :integer,
#         required: true,
#         description: 'checkout order'

#       response '200', 'successful' do
#         schema type: :array,
#                items: {
#                   type: :object,
#                   properties: {
#                     cart_id: { type: :integer },
#                     products:  { type: :array,
#                       items: { type: :object,
#                         properties: { product_id: { type: :integer },
#                                       quantity: { type: :integer },
#                                       unit_price: { type: :number },
#                                       total_price: { type: :number }
#                         }
#                       }
#                     },
#                     cart_total_price: { type: :number }
#                   }
#                 }
#         run_test!
#       end

#       response '404', 'not found' do
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/cart/list_checked_out_orders' do
#     get 'list_checked_out_orders' do
#       tags 'Order'
#       produces 'application/json'

#       response '200', 'successful' do
#         schema type: :array,
#                items: {
#                   type: :object,
#                   properties: {
#                     cart_id: { type: :integer },
#                     products:  { type: :array,
#                       items: { type: :object,
#                         properties: { product_id: { type: :integer },
#                                       quantity: { type: :integer },
#                                       unit_price: { type: :number },
#                                       total_price: { type: :number }
#                         }
#                       }
#                     },
#                     cart_total_price: { type: :number }
#                   }
#                 }
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/cart/list_in_progress_orders' do
#     get 'list_in_progress_orders' do
#       tags 'Order'
#       produces 'application/json'

#       response '200', 'successful' do
#         schema type: :array,
#                items: {
#                   type: :object,
#                   properties: {
#                     cart_id: { type: :integer },
#                     products:  { type: :array,
#                       items: { type: :object,
#                         properties: { product_id: { type: :integer },
#                                       quantity: { type: :integer },
#                                       unit_price: { type: :number },
#                                       total_price: { type: :number }
#                         }
#                       }
#                     },
#                     cart_total_price: { type: :number }
#                   }
#                 }
#         run_test!
#       end
#     end
#   end
# end
