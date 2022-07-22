class Feature < ApplicationRecord
  has_one :hotel
  validates :room, numericality: { greater_than: 0, less_than: 9999 }
  validates :pool, presence: { message: 'Feature pool is required.' }, inclusion: { in: [true, false] }
  validates :bar, presence: { message: 'Feature bar is required.' }, inclusion: { in: [true, false] }
  validates :air_conditioning, presence: { message: 'Feature air conditioning is required.' },
                               inclusion: { in: [true, false] }
  validates :tv, presence: { message: 'Feature tv is required.' }, inclusion: { in: [true, false] }
  validates :gym, presence: { message: 'Feature gym is required.' }, inclusion: { in: [true, false] }
end
