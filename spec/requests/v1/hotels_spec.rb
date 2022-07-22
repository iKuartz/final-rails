require 'swagger_helper'

RSpec.describe 'v1/hotels', type: :request do

  path '/v1/hotels' do

    get('list hotels') do
      response(200, 'successful') do

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
      tags 'Create hotel'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :hotel, in: :body, schema: {
        type: :object,
        properties: {
          hotel: { type: :object,
                  properties: {
                    room: { type: :boolean },
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
                    complement: { type: :string },
                    name: { type: :string },
                    description: { type: :string }
                  } }
        },
        required: [:room, :pool, :bar, :air_conditioning, :tv, :gym, :country, :state, :city, :neighbourhood, :street, :number, :name, :description]
      }
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']
        run_test!
      end
    end
  end
end
