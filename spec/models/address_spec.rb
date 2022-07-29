require 'rails_helper'

RSpec.describe Address, type: :model do

  it 'is valid with valid attributes' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: 100
    )
    expect(address).to be_valid
  end

  it 'is not valid without a country' do
    address = Address.new(
      
      country: nil,
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: 100
    )
    expect(address).to_not be_valid
  end

  it 'is not valid without a state' do
    address = Address.new(
      country: 'Brazil',
      state: nil,
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: 100
    )
    expect(address).to_not be_valid
  end

  it 'is not valid without a city' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: nil,
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: 100
    )
    expect(address).to_not be_valid
  end

  it 'is not valid without a neighbourhood' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: nil,
      street: 'Barata Ribeiro',
      number: 100
    )
    expect(address).to_not be_valid
  end

  it 'is not valid without a street' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: nil,
      number: 100
    )
    expect(address).to_not be_valid
  end

  it 'is not valid without a number' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: nil
    )
    expect(address).to_not be_valid
  end

  it 'is not valid if number is not an integer' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: 'Powerful Place'
    )
    expect(address).to_not be_valid
  end

  it 'is not valid if number is negative' do
    address = Address.new(
      country: 'Brazil',
      state: 'Rio de Janeiro',
      city: 'Rio de Janeiro',
      neighbourhood: 'Copacabana',
      street: 'Barata Ribeiro',
      number: -100
    )
    expect(address).to_not be_valid
  end
end
