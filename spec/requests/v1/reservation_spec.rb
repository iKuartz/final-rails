require 'swagger_helper'

RSpec.describe 'v1/reservation', type: :request do
  before :all do
    get '/v1/login/Ivan'
    body = JSON.parse response.body
    @token = body['token']
  end

  describe 'get reservation' do
    it 'should not work without a token' do
      get '/v1/reservation'
      expect(response).to have_http_status 500
    end

    it 'should work with a token' do
      get '/v1/reservation', headers: { token: @token }
      expect(response).to have_http_status 200
      body = JSON.parse response.body
      expect(body['reservations'].size).to eq 1
      expect(body['reservations']).to eq([{ 'id' => 1, 'reserved_rooms' => 10, 'hotel_id' => 1,
                                            'date_from' => '2022-08-08', 'date_to' => '2022-08-10' }])
    end
  end

  describe 'post reservation' do
    it 'should not work without a token' do
      post '/v1/reservation'
      expect(response).to have_http_status 500
    end

    it 'should work with a token and valid data' do
      post '/v1/reservation', headers: { token: @token }, params: {
        reservation: {
          reserved_rooms: 2,
          hotel_id: 1,
          start_date: '2022-08-08',
          end_date: '2022-08-10'
        }
      }
      expect(response).to have_http_status 200
      body = JSON.parse response.body
      expect(body['message']).to eq('Hotel reserved from 2022-08-08 to 2022-08-10.')
    end

    it 'should not work with a start date from the past' do
      post '/v1/reservation', headers: { token: @token }, params: {
        reservation: {
          reserved_rooms: 2,
          hotel_id: 1,
          start_date: '2020-08-08',
          end_date: '2022-08-10'
        }
      }
      expect(response).to have_http_status 501
      body = JSON.parse response.body
      expect(body['error']).to eq('Unable to create reservation[1x604]')
    end

    it 'should not work with an end date earlier than the start date' do
      post '/v1/reservation', headers: { token: @token }, params: {
        reservation: {
          reserved_rooms: 2,
          hotel_id: 1,
          start_date: '2022-08-08',
          end_date: '2020-08-10'
        }
      }
      expect(response).to have_http_status 501
      body = JSON.parse response.body
      expect(body['error']).to eq('Unable to create reservation[1x605]')
    end

    it 'should not work with zero or a negative number of reserved rooms' do
      post '/v1/reservation', headers: { token: @token }, params: {
        reservation: {
          reserved_rooms: -172,
          hotel_id: 1,
          start_date: '2022-08-08',
          end_date: '2022-08-10'
        }
      }
      expect(response).to have_http_status 501
      body = JSON.parse response.body
      expect(body['error']).to eq('Unable to create reservation[1x606]')
    end
  end

  describe 'delete reservation' do
    it 'should not work without a token' do
      delete '/v1/reservation/1'
      expect(response).to have_http_status 500
    end

    it 'should work with a token' do
      delete '/v1/reservation/1', headers: { token: @token }
      expect(response).to have_http_status 200
      body = JSON.parse response.body
      expect(body['message']).to eq('Reservation successfully destroyed')
    end
  end

  path '/v1/reservation' do
    get('list reservations') do
      description 'get reservation list for user'
      tags 'Reservations'
      produces 'application/json'
      parameter name: :token, in: :header, type: :string, required: true
      response(200, 'successful') do
        schema type: :object, properties: {
          reservations: {
            type: :array,
            items: {
              type: :object,
              properties: {
                reserved_rooms: { type: :integer },
                hotel_id: { type: :integer },
                start_date: { type: :string },
                end_date: { type: :string }
              }
            }
          }
        }
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

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        let(:token) { '' }
        run_test!
      end
    end

    post('create reservation') do
      description 'Create reservation for user'
      tags 'Reservations'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :token, in: :header, type: :string, required: true
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          reservation: {
            type: :object,
            properties: {
              reserved_rooms: { type: :integer },
              hotel_id: { type: :integer },
              start_date: { type: :string },
              end_date: { type: :string }
            }, required: %i[
              reserved_rooms
              hotel_id
              start_date
              end_date
            ]
          }
        }
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']
        let(:params) do
          {
            reservation: {
              reserved_rooms: 2,
              hotel_id: 1,
              start_date: '2022-08-08',
              end_date: '2022-08-10'
            }
          }
        end
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

      response(501, 'Unable to create reservation') do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_list: { type: :array,
                               items: { type: :string } }
               }, required: %i[error error_list]
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        let(:params) do
          {
            reservation: {
              reserved_rooms: -172,
              hotel_id: 1,
              start_date: '2022-08-08',
              end_date: '2021-08-10'
            }
          }
        end
        let(:token) { @token }
        run_test!
      end

      response(500, 'Invalid Token') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }, required: [:error]

        let(:token) { '' }
        let(:params) do
          {
            reservation: {
              reserved_rooms: -172,
              hotel_id: 1,
              start_date: '2022-08-08',
              end_date: '2022-08-10'
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

  path '/v1/reservation/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    delete('delete reservation') do
      description 'Create reservation for user'
      tags 'Reservations'
      produces 'application/json'
      parameter name: :token, in: :header, type: :string, required: true
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']
        let(:id) { 1 }
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

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        let(:id) { 1 }
        let(:token) { '' }
        run_test!
      end
    end
  end
end
