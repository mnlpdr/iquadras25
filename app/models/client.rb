# tem só que criar os campos pra senha na tabela clients
class Client < ApplicationRecord
    has_secure_password  # Vai requerer a gem bcrypt, caso não tenha, basta adicionar ao Gemfile e rodar `bundle install`
    
    validates :email, presence: true, uniqueness: true
  end

# rails generate migration AddPasswordDigestToClients password_digest:string
# rails db:migrate