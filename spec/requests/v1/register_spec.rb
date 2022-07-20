require 'swagger_helper'

RSpec.describe 'Register', type: :request do
  path '/v1/register' do
    get('register user') do
      tags 'Register'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :name, in: :body, type: :string

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
