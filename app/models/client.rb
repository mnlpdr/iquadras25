class Client < ApplicationRecord
    # Validações para garantir que nome e e-mail são obrigatórios
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }
  end
  