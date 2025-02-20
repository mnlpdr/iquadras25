class Court < ApplicationRecord

    has_many :reservations, dependent: :destroy
    has_many :court_sports
    has_many :sports, through: :court_sports

end
