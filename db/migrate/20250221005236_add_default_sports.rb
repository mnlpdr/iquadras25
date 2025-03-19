class AddDefaultSports < ActiveRecord::Migration[7.1]
  def up
    sports = [
      "Futsal", "Vôlei", "Handebol", "Basquete", "Tênis",
      "Futebol", "Rugby", "Futebol Americano", "Lacrosse",
      "Futvôlei", "Beach Tênis"
    ]

    sports.each do |sport_name|
      execute <<-SQL
        INSERT INTO sports (name, created_at, updated_at)
        VALUES ('#{sport_name}', NOW(), NOW())
        ON CONFLICT (name) DO NOTHING;
      SQL
    end
  end

  def down
    execute "TRUNCATE sports CASCADE;"
  end
end