class Payment < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  
  # Definir o enum para status usando a sintaxe correta para Rails 7
  enum :status, { pending: 0, completed: 1, failed: 2, refunded: 3 }
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :stripe_payment_intent_id, uniqueness: true, allow_nil: true
  
  # Garante que o status seja definido como pending por padrão
  after_initialize :set_default_status, if: :new_record?
  
  private
  
  def set_default_status
    self.status ||= :pending
  end
end
