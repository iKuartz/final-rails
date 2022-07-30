require 'rails_helper'

RSpec.describe Feature, type: :model do
  it 'is valid with valid attributes' do
    feature = Feature.new room: 2, pool: true, bar: false, air_conditioning: true, tv: true, gym: true
    expect(feature).to be_valid
  end

  describe 'Room' do
    it 'should have a value' do
      feature = Feature.new room: nil, pool: true, bar: false, air_conditioning: true, tv: true, gym: true
      expect(feature).to_not be_valid
    end

    it 'should be a number' do
      feature = Feature.new room: 'Ivan', pool: true, bar: false, air_conditioning: true, tv: true, gym: true
      expect(feature).to_not be_valid
    end

    it 'should be greater than zero' do
      feature = Feature.new room: -1, pool: true, bar: false, air_conditioning: true, tv: true, gym: true
      expect(feature).to_not be_valid
    end

    it 'should be less than 9999' do
      feature = Feature.new room: 10_000, pool: true, bar: false, air_conditioning: true, tv: true, gym: true
      expect(feature).to_not be_valid
    end
  end

  describe 'Pool' do
    it 'should have a value' do
      feature = Feature.new room: 3, pool: nil, bar: false, air_conditioning: true, tv: true, gym: true
      expect(feature).to_not be_valid
    end
  end

  describe 'Bar' do
    it 'should have a value' do
      feature = Feature.new room: 3, pool: true, bar: nil, air_conditioning: true, tv: true, gym: true
      expect(feature).to_not be_valid
    end
  end

  describe 'Air Conditioning' do
    it 'should have a value' do
      feature = Feature.new room: 3, pool: true, bar: false, air_conditioning: nil, tv: true, gym: true
      expect(feature).to_not be_valid
    end
  end

  describe 'TV' do
    it 'should have a value' do
      feature = Feature.new room: 3, pool: true, bar: false, air_conditioning: true, tv: nil, gym: true
      expect(feature).to_not be_valid
    end
  end

  describe 'GYM' do
    it 'should have a value' do
      feature = Feature.new room: 3, pool: true, bar: false, air_conditioning: true, tv: true, gym: nil
      expect(feature).to_not be_valid
    end
  end
end
