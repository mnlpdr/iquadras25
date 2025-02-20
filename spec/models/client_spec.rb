require 'rails_helper'

RSpec.describe Client, type: :model do
  context "validações" do
    it "é válido com nome e e-mail" do
      client = Client.new(name: "João Silva", email: "joao@example.com")
      expect(client).to be_valid
    end

    it "é inválido sem nome" do
      client = Client.new(email: "joao@example.com")
      expect(client).not_to be_valid
    end

    it "é inválido sem e-mail" do
      client = Client.new(name: "João Silva")
      expect(client).not_to be_valid
    end

    it "é inválido com e-mail duplicado" do
      Client.create(name: "João Silva", email: "joao@example.com")
      client_duplicado = Client.new(name: "Maria Souza", email: "joao@example.com")
      expect(client_duplicado).not_to be_valid
    end
  end
end
