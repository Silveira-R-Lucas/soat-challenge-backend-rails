class Api::V1::ClientsController < ActionController::API
  include ActionController::MimeResponds

  def create
    create_client_service = CreateClient.new(
      client_repository: ActiveRecordClientRepository.new,
      identity_provider_adapter: AuthenticationServiceAdapter.new
    )

    begin
      created_client = create_client_service.call(client_params)
      render json: { "successful": true, "status": 201, response: created_client }, status: :created
    rescue ArgumentError => e
      render json: { "successful": false, "status": 422, error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { "successful": false, "status": 422, errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado aconteceu: #{e.message}" }, status: :internal_server_error
    end
  end

  def identify_session
    identify_client_service = IdentifyClientSession.new(
      identity_provider_adapter: AuthenticationServiceAdapter.new
    )

    begin
      tokens = identify_client_service.call(cpf: client_params[:cpf])
      session[:tokens] = tokens
      render json: { "successful": true, "status": 200, message: "Sessão identificada" }, status: :ok
    rescue ArgumentError => e
      render json: { "successful": false, "status": 404, error: e.message }, status: :not_found
    rescue StandardError => e
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado ocorreu: #{e.message}" }, status: :internal_server_error
    end
  end

  def client_params
    params.permit(:name, :email, :cpf)
  end
end
