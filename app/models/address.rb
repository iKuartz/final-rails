class Address < ApplicationRecord
  has_one :hotel
  validate :country, presence: { message: 'Country can not be blank' }
  validate :state, presence: { message: 'State can not be blank' }
  validate :city, presence: { message: 'City can not be blank' }
  validate :neighbourhood, presence: { message: 'Neighbourhood can not be blank' }
  validate :street, presence: { message: 'Street can not be blank' }
  validate :number, presence: { message: 'Number can not be blank' }, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
