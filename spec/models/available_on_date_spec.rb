require 'rails_helper'

RSpec.describe AvailableOnDate, type: :model do
  before :all do
    @hotel = Hotel.find(1)
    @available_on_date = AvailableOnDate.new(
      date: '2022-08-12',
      rooms_occopied: 2,
      rooms_free: 18,
      available: true,
      hotel_id: @hotel.id
    )
  end
  it 'should be valid with valid attributes' do
    expect(@available_on_date).to be_valid
  end

  describe 'Date' do
    it 'should be present' do
      @available_on_date.date = nil
      expect(@available_on_date).to_not be_valid
      @available_on_date.date = '2022-08-12'
    end
  end
  describe 'Rooms Occupied' do
    it 'should be provided' do
      @available_on_date.rooms_occopied = nil
      expect(@available_on_date).to_not be_valid
      @available_on_date.rooms_occopied = 2
    end

    it 'should be a positive integer' do
      @available_on_date.rooms_occopied = -1
      expect(@available_on_date).to_not be_valid
      @available_on_date.rooms_occopied = 2
    end
  end

  describe 'available' do
    it 'should be present' do
      @available_on_date.available = nil
      expect(@available_on_date).to_not be_valid
      @available_on_date.available = true
    end
  end

  describe 'Rooms Free' do
    it 'should be present' do
      @available_on_date.rooms_free = nil
      expect(@available_on_date).to_not be_valid
      @available_on_date.rooms_free = 1
    end

    it 'should be positive integer' do
      @available_on_date.rooms_free = -2
      expect(@available_on_date).to_not be_valid
      @available_on_date.rooms_free = 18
    end
  end

  describe 'hotel_id' do
    it 'should be provided' do
      @available_on_date.hotel_id = nil
      expect(@available_on_date).to_not be_valid
      @available_on_date.hotel_id = 1
    end
  end
end
