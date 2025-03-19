class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0
      t.string :stripe_payment_id
      t.string :stripe_payment_intent_id
      t.jsonb :metadata, default: {}
      
      t.timestamps
    end
    
    add_index :payments, :stripe_payment_id, unique: true
    add_index :payments, :stripe_payment_intent_id, unique: true
  end
end