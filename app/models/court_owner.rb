class CourtOwner < ApplicationRecord
    has_secure_password 
  
    has_many :courts, dependent: :destroy
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates :phone_number, presence: true
    validates :address, presence: true
    validates :password, presence: true, length: { minimum: 6 }
  end
  