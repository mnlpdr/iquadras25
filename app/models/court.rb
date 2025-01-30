class Court < ApplicationRecord

    has_many :reservations, dependent: :destroy


end
