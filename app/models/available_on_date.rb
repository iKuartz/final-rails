class AvailableOnDate < ApplicationRecord
  belongs_to :hotel

  validates :date, presence: { message: 'Date should be provided' }
  validates :rooms_occopied, presence: { message: 'Rooms Occopied shold not be nil' },
                             numericality: { only_integer: true, greater_than: 0 }
  validates :available, inclusion: { in: [true, false] }
  validates :rooms_free, presence: { message: 'Rooms Free should have some value' },
                         numericality: { only_integer: true, greater_than: 0 }
end
