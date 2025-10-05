class Api::V1::ProductsController < ActionController::API
  include ActionController::MimeResponds
  def create
    create_product_service = CreateProduct.new(product_repository: ActiveRecordProductRepository.new)

    begin
      product = create_product_service.call(product_params)
      render json: { "successful": true, "status": 201, response: product }, status: :created
    rescue StandardError => e
      render json: { "successful": false, "status": 422, error: e.message }, status: :unprocessable_entity
    end
  end

  def update
    update_product_service = UpdateProduct.new(
      product_repository: ActiveRecordProductRepository.new
    )

    begin
      updated_product = update_product_service.call(id: product_params[:product_id], attributes: product_params)
      render json: { "successful": true, "status": 200, response: updated_product }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json:  { "successful": false, "status": 404, error: "Product not found" }, status: :not_found
    rescue StandardError => e
      render json: { "successful": false, "status": 422, errors: e.message }, status: :unprocessable_entity
    end
  end

  def show
    find_product_by_id_service = FindProductById.new(
      product_repository: ActiveRecordProductRepository.new
    )

    begin
      product = find_product_by_id_service.call(id: product_params[:product_id])

      if product
        render json: { "successful": true, "status": 200, response: product }, status: :ok
      else
        render json: { "successful": false, "status": 404, error: "Produto não encontrado" }, status: :not_found
      end
    rescue StandardError => e
      render json: { "successful": false, "status": 422, errors: e.message }, status: :internal_server_error
    end
  end

  def find_by_category
    find_products_by_category_use_case = FindProductsByCategory.new(
      product_repository: ActiveRecordProductRepository.new
    )

    begin
      products = find_products_by_category_use_case.call(category_name: product_params[:category])

      if products.any?
        render json: { "successful": true, "status": 202, response: products }, status: :accepted
      else
        render json: { "successful": false, "status": 404, error: "Nenhum produto encontrado para a Categoria #{product_params[:category]}" }, status: :not_found
      end
    rescue StandardError => e
      render json: { "successful": false, "status": 422, errors: e.message }, status: :internal_server_error
    end
  end

  def remove_product_from_catalog
    delete_product_service = DeleteProduct.new(
      product_repository: ActiveRecordProductRepository.new
    )

    begin
      deleted = delete_product_service.call(id: product_params[:product_id])

      if deleted
        render json: { "successful": true, "status": 204, message: "Produto deletado com sucesso" }, status: :no_content
      else
        render json: { "successful": false, "status": 404, error: "Produto não encontrado ou não pode ser deletado" }, status: :not_found
      end
    rescue ActiveRecord::RecordNotFound
      render json: { "successful": false, "status": 404, error: "Produto não encontrado" }, status: :not_found
    rescue StandardError => e
      render json: { "successful": false, "status": 422, error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def product_params
     params.permit(:name, :category, :product_id, :description, :price, :quantity, :images)
  end
end
