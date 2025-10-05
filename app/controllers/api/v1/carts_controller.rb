class Api::V1::CartsController < ActionController::API
  require_dependency Rails.root.join("app/infrastructure/external_apis/mercadopago/mercadopago_payment_gateway_adapter")
  include ActionController::MimeResponds
  before_action :set_cart

  def add_item
    add_product_to_cart_service = AddProductToCart.new(
      cart_repository: ActiveRecordCartRepository.new,
      product_repository: ActiveRecordProductRepository.new
    )

    client_id ||= cart_params[:client_id]
    client_id ||= @cart.client_id
    begin
      updated_cart = add_product_to_cart_service.call(
        client_id: client_id,
        product_id: cart_params[:product_id],
        quantity: cart_params[:quantity],
        cart: @cart
      )

      render json: { "successful": true, "status": 200, message: "Product adicionado ao carrinho com sucesso!", cart: @cart.to_h_for_display }, status: :ok
    rescue ArgumentError => e
      render json: { "successful": false, "status": 422, errors: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Erro ao adicionar produto ao carrinho: #{e.message}"
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado aconteceu." }, status: :internal_server_error
    end
  end

  def show
    render json: { "successful": true, "status": 200, response: @cart.to_h_for_display }, status: :ok
  end

  def payment_status
    render json:  { "successful": true, "status": 200,  id: @cart.id, payment_status: @cart.payment_status }, status: :ok
  end

  def create_payment
    generate_cart_payment_service = GenerateCartPayment.new(
      cart_repository: ActiveRecordCartRepository.new,
      payment_gateway_adapter: ::MercadoPago::PaymentGatewayAdapter.new
    )

    begin
      result = generate_cart_payment_service.call(cart: @cart)

      render json: { successful: true, status: 200,  cart: @cart.to_h_for_display, payment_details: result[:payment_details] }, status: :ok
    rescue ArgumentError => e
      case e.message
      when /Cart not found/
        render json: { successful: false, status: 404, error: e.message }, status: :not_found
      when /Cart is empty/
        render json: { successful: false, status: 422, error: e.message }, status: :unprocessable_entity
      when /Payment already generated/
        render json: { successful: false, status: 409, error: e.message }, status: :conflict
      when /Payment gateway failed/
        render json: { successful: false, status: 502, error: e.message }, status: :bad_gateway
      else
        render json: { successful: false, status: 422, error: e.message }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Erro inesperado ao gerar pagamento: #{e.message}"
      render json: { successful: false, status: 500, error: "Algo deu errado!" }, status: :internal_server_error
    end
  end

  def remove_item
    return render json: { "successful": false, "status": 400, errors: "Parâmetros faltantes: product_id" }, status: :bad_request if cart_params[:product_id].blank?

    remove_product_from_cart_service = RemoveProductFromCart.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      updated_cart = remove_product_from_cart_service.call(
        client_id: @cart.client_id,
        product_id: cart_params[:product_id],
        quantity: cart_params[:quantity],
        cart: @cart
      )

    render json: { "successful": true, "status": 200, msg: "Produto removido do carrinho com sucesso!" }, status: :accepted
    rescue ArgumentError => e
      render json: { "successful": false, "status": 422, errors: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Erro ao remover produto do carrinho: #{e.message}"
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado aconteceu" }, status: :internal_server_error
    end
  end

    def update_item
    if cart_params[:product_id].blank? || cart_params[:quantity].blank?
      render json:  { "successful": false, "status": 400, errors: "Parâmetros faltantes: product_id, quantity" }, status: :bad_request
      return
    end

    update_product_quantity_in_cart_service = UpdateProductQuantityInCart.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      updated_cart = update_product_quantity_in_cart_service.call(
        client_id: @cart.client_id,
        product_id: cart_params[:product_id],
        new_quantity: cart_params[:quantity].to_i,
        cart: @cart
      )

      render json: { "successful": true, "status": 200, msg: "Quantidade atualizada!" }, status: :accepted
    rescue ArgumentError => e
      render json: { errors: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Error ao atualizar quantidadde de item no carrinho: #{e.message}"
      render json: { errors: "Um erro inesperado ocorreu!" }, status: :internal_server_error
    end
  end

  def checkout
    checkout_cart_service = CheckoutCart.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      processed_cart = checkout_cart_service.call(cart: @cart)

      render json: { "successful": true, "status": 200, msg: "Pedido nº #{@cart.id}  enviado para cozinha!" }, status: :accepted
    rescue ArgumentError => e
      case e.message
      when /Payment pending/
        render json: { successful: false, status: 402, error: e.message }, status: :payment_required
      when /Cart not found/
        render json: { successful: false, status: 404, error: e.message }, status: :not_found
      when /empty cart/
        render json: { successful: false, status: 422, error: e.message }, status: :unprocessable_entity
      else
        render json: { successful: false, status: 422, error: e.message }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Erro durante checkout: #{e.message}"
      render json: { successful: false, status: 500, error: "Algo deu errado!" }, status: :internal_server_error
    end
  end

  def list_checked_out_orders
    list_checked_out_carts_use_case = ListCheckedOutCarts.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      carts = list_checked_out_carts_use_case.call

      render json: { "successful": true, "status": 200, response: carts.map(&:kitchen_display) }, status: :ok
    rescue StandardError => e
      Rails.logger.error "Error listing checked out carts: #{e.message}"
      render json: { errors: "Algo deu errado ao listar pedidos finalizados!" }, status: :internal_server_error
    end
  end

  def list_in_progress_orders
    list_in_progress_carts_use_case = ListInProgressCarts.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      carts = list_in_progress_carts_use_case.call
      render json: { "successful": true, "status": 200, response: carts.map(&:kitchen_display) }, status: :ok
    rescue StandardError => e
      Rails.logger.error "Error listing in progress carts: #{e.message}"
      render json: { errors: "Algo deu errado ao listar pedidos em andamento!" }, status: :internal_server_error
    end
  end

  def update_status_in_progress_orders
    return render json: { successful: false, status: 400, errors: "Parâmetros faltantes: progress_status" }, status: :bad_request if cart_params[:progress_status].blank?
    return render json: { successful: false, status: 400, errors: "Parâmetros faltantes: cart_id" }, status: :bad_request if cart_params[:cart_id].blank?

    update_cart_status_service = UpdateCartStatus.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      updated_cart = update_cart_status_service.call(
        cart_id: cart_params[:cart_id],
        new_status: cart_params[:progress_status]
      )

      render json: { successful: true, status: 200, msg: "Status atualizado!", cart: updated_cart.to_h_for_display }, status: :ok
    rescue ArgumentError => e
      case e.message
      when /Cart with ID .* not found/
        render json: { successful: false, status: 404, error: e.message }, status: :not_found
      when /Status inválido/
        render json: { successful: false, status: 400, error: e.message }, status: :bad_request
      else
        render json: { successful: false, status: 422, error: e.message }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Erro inesperado ao atualizar status do carrinho: #{e.message}"
      render json: { successful: false, status: 500, error: "Algo deu errado!" }, status: :internal_server_error
    end
  end

  private

  def set_cart
    current_client_id = session[:client_id] || cart_params[:client_id]
    current_cart_id = session[:cart_id] || cart_params[:cart_id]
    get_or_create_cart_service = GetOrCreateClientCart.new(
      cart_repository: ActiveRecordCartRepository.new
    )

    begin
      @cart = get_or_create_cart_service.call(client_id: current_client_id, cart_id: current_cart_id)
      session[:cart_id] ||= @cart.id
      session[:client_id] ||= @cart.client_id if session[:client_id].blank?
    rescue ArgumentError => e
      render json: { "successful": false, "status": 422, errors: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Erro ao configurar o carrinho: #{e.message}"
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado aconteceu ao configurar o carrinho" }, status: :internal_server_error
    end
  end

  def cart_params
    params.permit(:quantity, :product_id, :cart_id, :client_id, :progress_status)
  end
end
