require 'rails_helper'

RSpec.describe Hotel, type: :model do

  before :all do
    @feats_hot1 = Feature.find(1)
    @address_hot1 = Address.find(1)
    @user1 = User.find(1)
  end

  it 'is valid with valid attributes' do
    hotel = Hotel.create(
        feature_id: @feats_hot1.id
        address_id: @address_hot1.id
        user_id: @
        name:
        description:
        image:
    )
  end
end