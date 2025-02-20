# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Garante que os dados de esporte estão presentes
sports = [
  "Futsal", "Vôlei", "Handebol", "Basquete", "Tênis",
  "Futebol", "Rugby", "Futebol Americano", "Lacrosse",
  "Futvôlei", "Beach Tênis"
]

# Criar esportes caso não existam
sports.each do |sport_name|
  Sport.find_or_create_by(name: sport_name)
end

# Função para atribuir esportes relacionados ao tipo de quadra
def get_related_sports(court_type)
  case court_type
  when "Futsal"
    ["Futsal", "Vôlei", "Handebol", "Basquete", "Tênis"]
  when "Futebol"
    ["Futebol", "Rugby", "Futebol Americano", "Lacrosse"]
  when "Vôlei de Praia"
    ["Futvôlei", "Beach Tênis"]
  else
    []  # Caso não tenha um tipo específico, não atribui esportes
  end
end

# Criar 10 quadras aleatórias com a localização "João Pessoa"
10.times do
  # Definir o tipo de quadra aleatória (Futsal, Futebol, Vôlei de Praia, etc)
  court_type = ["Futsal", "Futebol", "Vôlei de Praia"].sample

  # Criar a quadra com nome aleatório, tipo e capacidade entre 10 e 50
  court = Court.create(
    name: "Quadra #{Faker::Lorem.word.capitalize}",
    location: "João Pessoa",
    capacity: rand(10..50)
  )

  # Selecionar esportes relacionados com o tipo da quadra
  related_sports = get_related_sports(court_type)

  # Associa os esportes relacionados à quadra
  court.sports = Sport.where(name: related_sports).sample(rand(1..3)) # Seleciona entre 1 e 3 esportes relacionados

end

puts "10 quadras com esportes relacionados foram criadas."
