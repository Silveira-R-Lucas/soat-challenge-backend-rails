class ActiveRecordClientRepository
  include ClientRepository

  def save(client)
    ar_client = client.id ? ClientModel.find(client.id) : ClientModel.new
    ar_client.name = client.name
    ar_client.email = client.email
    ar_client.cpf = client.cpf

    ar_client.save!

    client.id = ar_client.id
    client
  end

  def find(id)
    begin
      ar_client = ClientModel.find(id)
      Client.new(id: ar_client.id, name: ar_client.name, email: ar_client.email, cpf: ar_client.cpf)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def find_by_email(email)
    ar_client = ClientModel.find_by(email: email)
    if ar_client
      Client.new(id: ar_client.id, name: ar_client.name, email: ar_client.email, cpf: ar_client.cpf)
    else
      nil
    end
  end

  def find_by_cpf(cpf)
    ar_client = ClientModel.find_by(cpf: cpf)

    if ar_client
      Client.new(
        id: ar_client.id,
        name: ar_client.name,
        email: ar_client.email,
        cpf: ar_client.cpf
      )
    else
      nil
    end
  end
end
