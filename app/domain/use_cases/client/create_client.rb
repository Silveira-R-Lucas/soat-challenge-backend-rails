class CreateClient

  def initialize(client_repository:, identity_provider_adapter:)
    @client_repository = client_repository
    @identity_provider_adapter = identity_provider_adapter
  end

  def call(params)
    client = Client.new(params)
    @client_repository.save(client) 
    

    identity_result = @identity_provider_adapter.create_user(client)

    unless identity_result[:successful]
      Rails.logger.error "Falha ao sincronizar novo cliente com o serviço de identidade: #{identity_result[:body]}"
      client.destroy!
    end
    
    client 
  end
end