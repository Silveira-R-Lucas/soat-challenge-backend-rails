require "curb"
require "json"

class AuthenticationServiceAdapter
  def initialize
    @create_user_url = ENV.fetch("CREATE_USER_FUNCTION_URL")
    @identify_client_url = ENV.fetch("IDENTIFY_CLIENT_FUNCTION_URL")
  end

  def create_user(client)
    payload = {
      name: client.name,
      email: client.email,
      cpf: client.cpf
    }.to_json

    http = Curl.post(@create_user_url, payload) do |http_client|
      http_client.headers["Content-Type"] = "application/json"
    end

    successful = http.response_code.between?(200, 299)
    body = JSON.parse(http.body_str) rescue http.body_str

    { successful: successful, body: body }
  end

  def identify_session_by_cpf(cpf)
    payload = { cpf: cpf }.to_json

    http = Curl.post(@identify_client_url, payload) do |http_client|
      http_client.headers["Content-Type"] = "application/json"
    end

    if http.response_code.between?(200, 299)
      JSON.parse(http.body_str) rescue nil
    else
      Rails.logger.error "Falha na identificação via Azure Function: #{http.body_str}"
      nil
    end
  rescue Curl::Err::CurlError => e
    Rails.logger.error "Erro de Curl ao comunicar com a função de autenticação: #{e.message}"
    nil
  end
end
