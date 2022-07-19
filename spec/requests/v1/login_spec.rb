require 'swagger_helper'

RSpec.describe 'v1/login', type: :request do

  path '/v1/login' do

    post('login user') do
      tags 'Login'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ 'name' ]
      }
      response(200, 'successful') do
        schema type: :object,
          properties: {
            token: { type: :string },
          },
        required: [ 'token' ]
        run_test!
      end
    end
  end

  path '/v1/register' do

    post('register user') do
      response(200, 'registration successful') do
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
