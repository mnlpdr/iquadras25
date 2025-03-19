class Court < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: "owner_id"
    has_many :reservations, dependent: :restrict_with_error
    has_and_belongs_to_many :sports
  
    validates :name, presence: true
    validates :location, presence: true
    validates :capacity, presence: true, numericality: { greater_than: 0 }
    validates :price_per_hour, presence: true, numericality: { greater_than: 0 }
    validates :owner, presence: true
  
    # Escopo para encontrar quadras por dono
    scope :by_owner, ->(owner_id) { where(owner_id: owner_id) }
    scope :by_sport, ->(sport_id) { joins(:court_sports).where(court_sports: { sport_id: sport_id }) if sport_id.present? }

    validate :owner_must_be_court_owner

    def self.sport_type_options
      sport_types.keys.map { |k| [k.titleize, k] }
    end

    private

    def owner_must_be_court_owner
      if owner.present? && !owner.role.to_sym.eql?(:court_owner)
        errors.add(:owner, "deve ser um dono de quadra")
      end
    end
end
  