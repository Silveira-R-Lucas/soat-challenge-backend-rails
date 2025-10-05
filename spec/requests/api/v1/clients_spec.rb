# require 'swagger_helper'

# RSpec.describe 'api/v1/clients', type: :request do
#   path '/api/v1/register' do
#     post 'register' do
#       tags 'Clients'
#       consumes 'application/json'
#       produces 'application/json'

#       parameter name: :cpf,
#         in: :body,
#         description: 'User registry parameters',
#         schema: {
#           type: :object,
#           properties: {
#             cpf: { type: :string },
#             name: { type: :string },
#             email: { type: :string }
#           },
#           required: %w[cpf name email]
#         }

#       response '200', 'successful' do
#         schema type: :object,
#               properties: {
#                 User_id: { type: :string },
#                 cpf: { type: :string },
#                 name: { type: :string },
#                 email: { type: :string }
#               }
#       run_test!
#       end

#       response '422', 'successful' do
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/sign_in' do
#     post 'sign in' do
#       tags 'Clients'
#       consumes 'application/json'
#       produces 'application/json'

#       parameter name: :cpf,
#         in: :body,
#         description: 'User identification',
#         schema: {
#           type: :object,
#           properties: {
#             cpf: { type: :string }
#           },
#           required: %w[cpf]
#         }

#       response '200', 'successful' do
#         schema type: :object,
#               properties: {
#                 msg: { type: :string }
#               }
#       run_test!
#       end

#       response '404', 'not found' do
#         run_test!
#       end

#       response '422', 'unprocessable entity' do
#         run_test!
#       end
#     end
#   end
# end
