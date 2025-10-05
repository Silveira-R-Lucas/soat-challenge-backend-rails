require 'swagger_helper'

RSpec.describe 'api/v1/products', type: :request do
  path '/api/v1/create_product' do
    post 'create_product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :product,
        in: :body,
        description: 'Product registry parameters',
        schema: {
          type: :object,
          properties: {
            name: { type: :string },
            category: { type: :string },
            description: { type: :string },
            price: { type: :number },
            quantity: { type: :integer },
            images: { type: :file }
          },
          required: %w[name category description price quantity images]
        }

      response '200', 'successful' do
        schema type: :object,
                properties: {
                product_id: { type: :string },
                category: { type: :string },
                description: { type: :string },
                price: { type: :number },
                quantity: { type: :integer },
                images: { type: :file }
              }
        run_test!
      end

      response '422', 'unprocessable entity' do
        run_test!
      end
    end
  end

  path '/api/v1/products_by_category/{category}' do
    get 'find_by_category' do
      tags 'Products'
      produces 'application/json'

      parameter name: :category,
        in: :path,
        type: :string,
        required: true,
        description: 'find productsby category name'

      response '200', 'successful' do
        schema type: :array,
               items: {
                  type: :object,
                  properties: {
                    product_id: { type: :string },
                    category: { type: :string },
                    description: { type: :string },
                    price: { type: :number },
                    quantity: { type: :integer },
                    images: { type: :file }
                  }
                }
        run_test!
      end

      response '404', 'not found' do
        run_test!
      end
    end
  end

  path '/api/v1/remove_product_from_catalog/{product_id}' do
    delete 'delete product from catalog' do
      tags 'Products'
      produces 'application/json'

      parameter name: :product_id,
        in: :path,
        type: :integer,
        required: true,
        description: 'find product by id'

      response '200', 'successful' do
        schema type: :object,
              properties: {
                msg: { type: :string }
              },
              required: [ 'product_id' ]
        run_test!
      end

      response '404', 'not found' do
        run_test!
      end
    end
  end

  path '/api/v1/update_product/{product_id}' do
    post 'update_product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :product_id,
        in: :path,
        type: :integer,
        required: true

      parameter name: :product,
        in: :body,
        description: 'Product update parameters',
        schema: {
          type: :object,
          properties: {
            name: { type: :string },
            category: { type: :string },
            description: { type: :string },
            price: { type: :number },
            quantity: { type: :integer },
            images: { type: :file }
          }
        }

      response '200', 'successful' do
        schema type: :object,
                properties: {
                product_id: { type: :string },
                category: { type: :string },
                description: { type: :string },
                price: { type: :number },
                quantity: { type: :integer },
                images: { type: :file }
              }
        run_test!
      end

      response '422', 'unprocessable entity' do
        run_test!
      end

      response '404', 'not found' do
        run_test!
      end
    end

    patch 'update_product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :product_id,
        in: :path,
        type: :integer,
        required: true

      parameter name: :product,
        in: :body,
        description: 'Product update parameters',
        schema: {
          type: :object,
          properties: {
            name: { type: :string },
            category: { type: :string },
            description: { type: :string },
            price: { type: :number },
            quantity: { type: :integer },
            images: { type: :file }
          },
          required: %w[name category description price quantity images]
        }

      response '200', 'successful' do
        schema type: :object,
                properties: {
                product_id: { type: :string },
                category: { type: :string },
                description: { type: :string },
                price: { type: :number },
                quantity: { type: :integer },
                images: { type: :file }
              }
        run_test!
      end

      response '422', 'unprocessable entity' do
        run_test!
      end

      response '404', 'not found' do
        run_test!
      end
    end
  end
end
