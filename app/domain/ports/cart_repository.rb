module CartRepository
  def find_by_client_id(client_id)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def save(cart)
    raise NotImplementedError
  end

  def find_or_create_by_client_id(client_id)
    raise NotImplementedError
  end

  def find_by_status(status)
    raise NotImplementedError
  end

  def find_all
    raise NotImplementedError
  end

  def create_anonymous_cart
    raise NotImplementedError
  end
end
