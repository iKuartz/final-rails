class Reservation < ApplicationRecord
  belongs_to :hotel
  belongs_to :user
  validates :reserved_rooms, numericality: { message: 'reserved_rooms must be a number', greater_than: 0 }
  validates :date_from, presence: { message: 'Initial date can\'t be empty' }
  validates :date_to, presence: { message: 'Final date can\'t be empty' }

  # def validate_date
  #   if date_from.class
  #   end
  # end
end
