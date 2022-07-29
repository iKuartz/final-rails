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
  # path '/v1/register' do
  #   post('register user') do
  #     tags 'Register'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     parameter name: :name, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         user: { type: :object,
  #                 properties: {
  #                   name: { type: :string }
  #                 } }
  #       },
  #       required: ['name']
  #     }

  #     response(200, 'successful') do
  #       schema type: :object,
  #              properties: {
  #                message: { type: :string }
  #              },
  #              required: ['message']
  #       run_test!
  #     end
  #     response(500, 'error') do
  #       schema type: :object,
  #              properties: {
  #                message: { type: :string },
  #                error: {
  #                  oneOf: [
  #                    { type: :string }, { type: :array, items: { type: :string } }
  #                  ]
  #                }
  #              },
  #              required: %w[message error]
  #       run_test!
  #     end
  #   end
  # end
end
