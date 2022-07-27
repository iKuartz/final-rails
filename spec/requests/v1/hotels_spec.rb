require 'swagger_helper'

RSpec.describe 'v1/hotels', type: :request do
  before :all do
    get '/v1/login/Ivan'
    body = JSON.parse response.body
    @token = body['token']
  end

  it 'returns a subset of hotels on limit' do
    get '/v1/hotels', params: { limit: 1, token: @token }

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
                                   'user_id' => 1 }
                               ])
  end

  it 'return a subset of hotels on limit and offset' do
    get '/v1/hotels', params: { limit: 1, offset: 1, token: @token }

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
                                   'user_id' => 2 }
                               ])
  end

  # path '/v1/hotels' do
  #   get('list hotels') do

  #     response(200, 'successful') do
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   post('create hotel') do
  #     tags 'Create hotel'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     let(:token) { "token: '#{@token}'" }
  #     # parameter name: :token, in: :body, type: :string
  #     let(:hotel) { '' }
  #     parameter name: :hotel, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         token: { type: :string},
  #         hotel: { type: :object,
  #                  properties: {
  #                    room: { type: :boolean },
  #                    pool: { type: :boolean },
  #                    bar: { type: :boolean },
  #                    air_conditioning: { type: :boolean },
  #                    tv: { type: :boolean },
  #                    gym: { type: :boolean },
  #                    country: { type: :string },
  #                    state: { type: :string },
  #                    city: { type: :string },
  #                    neighbourhood: { type: :string },
  #                    street: { type: :string },
  #                    number: { type: :integer },
  #                    complement: { type: :string },
  #                    name: { type: :string },
  #                    description: { type: :string }
  #                  } }
  #       },
  #       required: %i[room pool bar air_conditioning tv gym country state city neighbourhood street
  #                    number name description]
  #     }

  #     response(200, 'successful') do
  #       let(:token) { @token }
  #       parameter name: :token, in: :body, type: :string
  #       schema type: :object,
  #              properties: {
  #                message: { type: :string }
  #              },
  #              required: ['message']
  #       run_test! do |response|
  #         p response.body
  #       end
  #     end

  #     response(500, 'successful') do
  #       run_test! do |response|
  #         p request.body.string
  #         p response.body
  #       end
  #     end
  #   end
  # end
end
