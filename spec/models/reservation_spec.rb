require 'rails_helper'

RSpec.describe Reservation, type: :model do
  before :all do
    @hotel1 = Hotel.find(1)
    @user1 = User.find(1)
  end

  it 'is valid with valid attributes' do
    reservation = Reservation.create(
      hotel_id: @hotel1.id,
      user_id: @user1.id,
      reserved_rooms: 1,
      date_from: '2022-08-08',
      date_to: '2022-08-12'
    )
    expect(reservation).to be_valid
  end

  it 'is not valid without hotel' do
    reservation = Reservation.create(
      hotel_id: nil,
      user_id: @user1.id,
      reserved_rooms: 1,
      date_from: '2022-08-08',
      date_to: '2022-08-12'
    )
    expect(reservation).to_not be_valid
  end

  it 'is not valid without user' do
    reservation = Reservation.create(
      hotel_id: @hotel1.id,
      user_id: nil,
      reserved_rooms: 1,
      date_from: '2022-08-08',
      date_to: '2022-08-12'
    )
    expect(reservation).to_not be_valid
  end

  it 'is not valid without rooms' do
    reservation = Reservation.create(
      hotel_id: @hotel1.id,
      user_id: @user1.id,
      reserved_rooms: nil,
      date_from: '2022-08-08',
      date_to: '2022-08-12'
    )
    expect(reservation).to_not be_valid
  end

  it 'is not valid with less than one room' do
    reservation = Reservation.create(
      hotel_id: @hotel1.id,
      user_id: @user1.id,
      reserved_rooms: -10,
      date_from: '2022-08-08',
      date_to: '2022-08-12'
    )
    expect(reservation).to_not be_valid
  end

  it 'is not valid without initial date' do
    reservation = Reservation.create(
      hotel_id: @hotel1.id,
      user_id: @user1.id,
      reserved_rooms: 1,
      date_from: nil,
      date_to: '2022-08-12'
    )
    expect(reservation).to_not be_valid
  end

  it 'is not valid without final date' do
    reservation = Reservation.create(
      hotel_id: @hotel1.id,
      user_id: @user1.id,
      reserved_rooms: 1,
      date_from: '2022-08-08',
      date_to: nil
    )
    expect(reservation).to_not be_valid
  end
end
