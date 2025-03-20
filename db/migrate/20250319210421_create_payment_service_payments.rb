class CreatePaymentServicePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_service_payments do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0
      t.string :stripe_payment_intent_id
      t.string :stripe_payment_id
      t.integer :reservation_id, null: false
      t.integer :user_id, null: false
      t.json :metadata, default: {}

      t.timestamps
    end
    
    add_index :payment_service_payments, :stripe_payment_intent_id, unique: true
    add_index :payment_service_payments, :reservation_id
    add_index :payment_service_payments, :user_id
  end
end