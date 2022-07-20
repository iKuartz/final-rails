class User < ApplicationRecord
  validates :name, presence: { message: 'Name can\'t be empty' }
end
