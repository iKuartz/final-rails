require 'rails_helper'

RSpec.describe Hotel, type: :model do
  before :all do
    @feats_hot1 = Feature.find(1)
    @address_hot1 = Address.find(1)
    @user1 = User.find(1)
  end

  it 'is valid with valid attributes' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: 'Where all your results are green'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to be_valid
  end

  it 'saves to the database' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: 'Where all your results are green'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    hotel.save
    expect(hotel.new_record?).to be false
  end

  it 'is not valid without feature' do
    hotel = Hotel.new(
      feature_id: nil,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: 'Where all your results are green'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to_not be_valid
  end

  it 'is not valid without address' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: nil,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: 'Where all your results are green'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to_not be_valid
  end

  it 'is not valid without user' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: nil,
      name: 'Royal Test Hotel',
      description: 'Where all your results are green'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to_not be_valid
  end

  it 'is not valid without name' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: nil,
      description: 'Where all your results are green'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to_not be_valid
  end

  it 'is not valid without description' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: nil
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to_not be_valid
  end

  it 'is not valid with a description shorter than 20 characters' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: 'Green test'
    )
    hotel.image.attach(io: File.open(Rails.root.join('app/assets/images/hotel1.jpg')), filename: 'hotel1.jpg')
    expect(hotel).to_not be_valid
  end

  it 'is not valid without image' do
    hotel = Hotel.new(
      feature_id: @feats_hot1.id,
      address_id: @address_hot1.id,
      user_id: @user1.id,
      name: 'Royal Test Hotel',
      description: 'Where all your results are green'
    )

    expect(hotel).to_not be_valid
  end
end
