class Payment < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :stripe_payment_id, uniqueness: true, allow_nil: true
  
  enum status: {
    pending: 0,
    completed: 1,
    failed: 2,
    refunded: 3
  }
end
