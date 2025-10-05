class IdentifyClientSession
  def initialize(identity_provider_adapter:)
    @identity_provider_adapter = identity_provider_adapter
  end

  def call(cpf:)
    raise ArgumentError, "CPF não pode estar vazio." if cpf.blank?

    tokens = @identity_provider_adapter.identify_session_by_cpf(cpf)

    raise ArgumentError, "CPF não encontrado ou falha na autenticação." unless tokens

    tokens
  end
end
