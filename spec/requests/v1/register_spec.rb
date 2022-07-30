# rubocop:disable Metrics/BlockLength
require 'swagger_helper'
RSpec.describe 'Register', type: :request do
  it 'should have register route' do
    post '/v1/register', params: { user: { name: 'Fabrizo' } }
    expect(response).to have_http_status :success
  end

  it 'should not register user if the name exists in database' do
    post '/v1/register', params: { user: { name: 'Ivan' } }
    expect(response).to have_http_status 500
  end
  path '/v1/register' do
    post('register user') do
      tags 'Register'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string }
            },
            required: ['name']
          }
        }
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']

        let(:params) { { user: { name: 'Lisandro' } } }
        run_test!
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
      end
      response(500, 'error') do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 error: { type: :string }
               },
               required: %w[message error]

        let(:params) { { user: { name: 'Ivan' } } }
        run_test!
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
