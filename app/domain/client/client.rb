class Client
  attr_accessor :id, :name, :email, :cpf

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @email = attributes[:email]
    @cpf = attributes[:cpf]
  end

  def valid?
    !name.blank? && !email.blank? && email.include?("@")
  end

  def persisted?
    !id.nil?
  end

  def to_h
    {
      id: id,
      name: name,
      email: email,
      cpf: cpf
    }
  end
end
