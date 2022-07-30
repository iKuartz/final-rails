require 'swagger_helper'

RSpec.describe 'v1/hotels', type: :request do
  before :all do
    get '/v1/login/Ivan'
    body = JSON.parse response.body
    @token = body['token']
    file = Rails.root.join('app', 'assets', 'images', 'hotel1.jpg')
    @image = ActiveStorage::Blob.create_and_upload!(
    io: File.open(file, 'rb'),
      filename: 'hotel1.jpg',
      content_type: 'image/jpeg' # Or figure it out from `name` if you have non-JPEGs
    ).signed_id
  end

  it 'should not work without a token' do
    get '/v1/hotels', params: { limit: 1 }
    expect(response).to have_http_status 500
  end

  it 'returns a subset of hotels on limit' do
    get '/v1/hotels', params: { limit: 1 }, headers: { token: @token }

    expect(response).to have_http_status :success

    body = JSON.parse response.body

    expect(body['data'].size).to eq 1

    expect(body['data']).to eq([
                                 { 'address' =>
                                    { 'city' => 'Penedo',
                                      'complement' => nil,
                                      'country' => 'Brazil',
                                      'id' => 1,
                                      'neighbourhood' => 'Centro',
                                      'number' => 31,
                                      'state' => 'Rio de Janeiro',
                                      'street' => 'Avenida das três cachoeiras' },
                                   'description' =>
                                    'An unforgattable experience for the lovers of chocolate all around the world!',
                                   'feature' =>
                                    { 'air_conditioning' => true,
                                      'bar' => true,
                                      'gym' => false,
                                      'id' => 1,
                                      'pool' => true,
                                      'room' => 20,
                                      'tv' => false },
                                   'id' => 1,
                                   'name' => 'Chocolate house Hotel',
                                   'user_id' => 1,
                                   'image_path' => body['data'][0]['image_path'] }
                               ])
  end

  it 'return a subset of hotels on limit and offset' do
    get '/v1/hotels', params: { limit: 1, offset: 1 }, headers: { token: @token }

    expect(response).to have_http_status :success

    body = JSON.parse response.body

    expect(body['data'].size).to eq 1

    expect(body['data']).to eq([
                                 { 'address' =>
                                     { 'city' => 'Skardu',
                                       'complement' => nil,
                                       'country' => 'Pakistan',
                                       'id' => 2,
                                       'neighbourhood' => 'Downtown',
                                       'number' => 11,
                                       'state' => 'Gilgid',
                                       'street' => '54th Street' },
                                   'description' =>
                                     'Feel the soothing breeze of the mountains and relax in the jewel of Skardu!',
                                   'feature' =>
                                    { 'air_conditioning' => true,
                                      'bar' => false,
                                      'gym' => true,
                                      'id' => 2,
                                      'pool' => false,
                                      'room' => 16,
                                      'tv' => true },
                                   'id' => 2,
                                   'name' => 'Peaceful Mountain Hotel',
                                   'user_id' => 2,
                                   'image_path' => body['data'][0]['image_path'] }
                               ])
  end

  it 'adds new hotel on post' do
    post '/v1/hotels', headers: { token: @token }, params: {
      hotel: {
        room: 3,
        pool: true,
        bar: true,
        air_conditioning: true,
        tv: true,
        gym: true,
        country: 'Brazilkistan',
        state: 'Paradise',
        city: 'Best City Ever',
        neighbourhood: 'Angels Meadows',
        street: 'Peace St.',
        number: 0,
        complement: 'Building n. 999',
        name: 'Great Hotel Resort',
        description: 'AMAZING!!!!!!! 20 Characters needed for success in life.',
        image: fixture_file_upload('app/assets/images/hotel4.jpg', 'image/png')
      }
    }
    expect(response).to have_http_status 200
    body = JSON.parse response.body
    expect(body['message']).to eq('Hotel created successfully')
  end

  path '/v1/hotels' do
    get('get list of hotels') do
      description 'Based on limit and offset it returns list of hotels. It returns maximum of 100 hotels in one request. If limit is not given it returns 10 hotels if present.'
      tags 'Hotel'
      produces 'application/json'
      parameter name: :limit, in: :query, type: :integer
      parameter name: :offset, in: :query, type: :integer
      parameter name: :token, in: :header, type: :string, required: true

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       address: {
                         type: :object,
                         properties: {
                           city: { type: :string },
                           complement: { type: :string, nullable: true },
                           country: { type: :string },
                           id: { type: :integer },
                           neighbourhood: { type: :string },
                           number: { type: :integer },
                           state: { type: :string },
                           street: { type: :string }
                         }
                       },
                       description: { type: :string },
                       feature: {
                         type: :object,
                         properties: {
                           air_conditioning: { type: :boolean },
                           bar: { type: :boolean },
                           gym: { type: :boolean },
                           id: { type: :integer },
                           pool: { type: :boolean },
                           room: { type: :integer },
                           tv: { type: :boolean }
                         }
                       },
                       id: { type: :integer },
                       name: { type: :string },
                       user_id: { type: :integer },
                       image_path: { type: :string }
                     }
                   }
                 }
               }, required: [:data]

        let(:limit) { 1 }
        let(:offset) { 1 }
        let(:token) { @token }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(500, 'Invalid Token') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }, required: [:error]

        let(:limit) { 1 }
        let(:offset) { 1 }
        let(:token) { '' }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create hotel') do
      description 'Add new hotel based on information'
      tags 'Hotel'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :token, in: :header, type: :string, required: true
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          hotel: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              room: { type: :integer },
              pool: { type: :boolean },
              bar: { type: :boolean },
              air_conditioning: { type: :boolean },
              tv: { type: :boolean },
              gym: { type: :boolean },
              country: { type: :string },
              state: { type: :string },
              city: { type: :string },
              neighbourhood: { type: :string },
              street: { type: :string },
              number: { type: :integer },
              complement: { type: :string }
            }, required: %i[
              name
              description
              room
              pool
              bar
              air_conditioning
              tv
              gym
              country
              state
              city
              neighbourhood
              street
              number
            ]
          }
        }
      }

      let(:params) do
        {
          hotel: {
            room: 3,
            pool: true,
            bar: true,
            air_conditioning: true,
            tv: true,
            gym: true,
            country: 'Brazilkistan',
            state: 'Paradise',
            city: 'Best City Ever',
            neighbourhood: 'Angels Meadows',
            street: 'Peace St.',
            number: 0,
            complement: 'Building n. 999',
            name: 'Great Hotel Resort',
            description: 'AMAZING!!!!!!! 20 Characters needed for success in life.',
            image: @image
          }
        }
      end

      response(200, 'Hotel Added') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']

        let(:token) { @token }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(500, 'Invalid Token') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }, required: [:error]

        let(:token) { '' }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(501, 'Unable to save to database') do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_list: { type: :array,
                               items: { type: :string } }
               }, required: %i[error error_list]

        let(:token) { @token }
        let(:params) do
          {
            hotel: {
              image: fixture_file_upload('app/assets/images/hotel4.jpg', 'image/png')
            }
          }
        end
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
