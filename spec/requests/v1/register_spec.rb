require 'swagger_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Register', type: :request do
  path '/v1/register' do
    post('register user') do
      tags 'Register'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :name, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']
        run_test!
      end
      response(500, 'error') do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 error: {
                   oneOf: [
                     { type: :string }, { type: :array, items: { type: :string } }
                   ]
                 }
               },
               required: %w[message error]
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
