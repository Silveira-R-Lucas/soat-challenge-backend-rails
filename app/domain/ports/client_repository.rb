module ClientRepository
  def save(client)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def find_by_email(email)
    raise NotImplementedError
  end

  def find_by_cpf(cpf)
    raise NotImplementedError
  end
end
