class Hotel < ApplicationRecord
    has_one :feature
    has_one :address
    has_many :reservations
    has_many :available_on_dates
end