module ProductRepository
  def save(product)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def find_by_category(category_name)
    raise NotImplementedError
  end

  def find_all
    raise NotImplementedError
  end

  def delete(id)
    raise NotImplementedError
  end
end
