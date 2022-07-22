class Address < ApplicationRecord
  has_one :hotel
  validates :country, presence: { message: 'Country can not be blank' }
  validates :state, presence: { message: 'State can not be blank' }
  validates :city, presence: { message: 'City can not be blank' }
  validates :neighbourhood, presence: { message: 'Neighbourhood can not be blank' }
  validates :street, presence: { message: 'Street can not be blank' }
  validates :number, presence: { message: 'Number can not be blank' }, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
