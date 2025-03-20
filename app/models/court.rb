class Court < ApplicationRecord
    belongs_to :owner, class_name: 'User'
    has_many :reservations, dependent: :restrict_with_error
    has_and_belongs_to_many :sports
    has_one_attached :photo
  
    validates :name, presence: true
    validates :location, presence: true
    validates :capacity, presence: true, numericality: { greater_than: 0 }
    validates :price_per_hour, presence: true, numericality: { greater_than: 0 }
    validates :owner, presence: true
    
    # Validação para a foto
    validate :acceptable_photo, if: -> { photo.attached? }
  
    # Escopo para encontrar quadras por dono
    scope :by_owner, ->(owner_id) { where(owner_id: owner_id) }
    scope :by_sport, ->(sport_id) { joins(:court_sports).where(court_sports: { sport_id: sport_id }) if sport_id.present? }

    validate :owner_must_be_court_owner

    def self.sport_type_options
      sport_types.keys.map { |k| [k.titleize, k] }
    end

    # Método auxiliar para verificar se tem foto
    def has_photo?
      photo.attached?
    end
  
    # Método para obter URL da foto ou imagem padrão
    def photo_url
      if photo.attached?
        Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true)
      else
        ActionController::Base.helpers.asset_path('default_court.jpg')
      end
    end

    private

    def owner_must_be_court_owner
      if owner.present? && !owner.role.to_sym.eql?(:court_owner)
        errors.add(:owner, "deve ser um dono de quadra")
      end
    end
    
    def acceptable_photo
      return unless photo.attached?
      
      # Verificar tamanho
      if photo.blob.byte_size > 5.megabytes
        errors.add(:photo, "deve ser menor que 5MB")
        photo.purge # Remove o anexo inválido
      end
      
      # Verificar tipo de conteúdo
      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(photo.content_type)
        errors.add(:photo, "deve ser JPEG ou PNG")
        photo.purge # Remove o anexo inválido
      end
    end
end
  