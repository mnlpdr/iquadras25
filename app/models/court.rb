class Court < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: "owner_id"
    has_many :reservations, dependent: :destroy
  
    validates :name, presence: true
    validates :location, presence: true
    validates :capacity, presence: true, numericality: { greater_than: 0 }
    validates :price_per_hour, presence: true, numericality: { greater_than: 0 }
    validates :owner, presence: true
  
    # Escopo para encontrar quadras por dono
    scope :by_owner, ->(owner_id) { where(owner_id: owner_id) }
  end
  