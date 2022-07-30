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

  path '/v1/login/{name}' do
    get('Logs user in') do
      description 'Logs the user based on user name if the user exists.'
      tags 'Login Route'
      produces 'application/json'
      parameter name: 'name', in: :path, type: :string, description: 'Name of registered user'

      response(200, 'User Present in database') do
        schema(type: :object,
               properties: {
                 token: { type: :string }
               })

        let(:name) { 'Ivan' }
        run_test!
      end

      response(404, 'User does not exist') do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 error: { type: :string }
               }

        let(:name) { '123' }
        run_test!
      end
    end
  end

  # path '/v1/register' do

  #   post('create login') do
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
  # end
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
