class User < ApplicationRecord
  has_many :reservations
  has_many :hotels
  validates :name, presence: { message: 'Name can\'t be empty' }
end
