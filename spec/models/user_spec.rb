require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid name' do
    user = User.create(
      name: 'Robert Williamson Jr.'
    )
    expect(user).to be_valid
  end
end
