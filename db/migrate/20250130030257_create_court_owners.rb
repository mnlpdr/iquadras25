class CreateCourtOwners < ActiveRecord::Migration[7.0]
  def change
    create_table :court_owners do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :address, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :court_owners, :email, unique: true  # Adiciona índice único ao email
  end
end
