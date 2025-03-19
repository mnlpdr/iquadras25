class Sport < ApplicationRecord
  has_many :court_sports, dependent: :destroy
  has_many :courts, through: :court_sports
  
  validates :name, presence: true, uniqueness: true
end 