require 'swagger_helper'

RSpec.describe 'Login', type: :request do
  path '/v1/login/{name}' do
    get('login user') do
      tags 'Login'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :name, in: :path, type: :string

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 token: { type: :string }
               },
               required: ['token']
        run_test!
      end

      response(404, 'error') do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 error: { type: :string }
               },
               required: %w[message error]
        run_test!
      end
    end
  end
end
