class Feature < ApplicationRecord
  has_one :hotel
  validates :room, numericality: { greater_than: 0, less_than: 9999 }
  validates :pool, inclusion: { in: [true, false] }
  validates :bar, inclusion: { in: [true, false] }
  validates :air_conditioning, inclusion: { in: [true, false] }
  validates :tv, inclusion: { in: [true, false] }
  validates :gym, inclusion: { in: [true, false] }
end
