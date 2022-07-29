require 'swagger_helper'

RSpec.describe 'Login', type: :request do
  it 'should have a login route' do
    get '/v1/login/Ivan'
    expect(response).to have_http_status :success
  end

  it 'should fail if user not present' do
    get '/v1/login/A' do
      expect(response).to have_http_status 500
    end
  end
  # path '/v1/login/{name}' do
  #   get('login user') do
  #     tags 'Login'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     parameter name: :name, in: :path, type: :string

  #     response(200, 'successful') do
  #       schema type: :object,
  #              properties: {
  #                token: { type: :string }
  #              },
  #              required: ['token']
  #       run_test!
  #     end

  #     response(404, 'error') do
  #       schema type: :object,
  #              properties: {
  #                message: { type: :string },
  #                error: { type: :string }
  #              },
  #              required: %w[message error]
  #       run_test!
  #     end
  #   end
  # end
end
