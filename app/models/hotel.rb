class Hotel < ApplicationRecord
  belongs_to :feature
  has_one :address
  has_many :reservations
  has_many :available_on_dates
  belongs_to :user

  validates :name, presence: { message: 'Name can\'t be blank' }
  validates :description, presence: { message: 'Description should be given' }, length: { minimum: 20, maximum: 2000 }
  validates :image, presence: { message: 'Hotel image should be provided.' }
  has_one_attached :image
end
