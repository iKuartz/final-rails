class User < ApplicationRecord
  has_many :reservations
  validates :name, presence: { message: 'Name can\'t be empty' }
end
