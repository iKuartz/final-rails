require 'swagger_helper'

RSpec.describe 'v1/login', type: :request do

  path '/v1/login' do

    get('login user') do
      tags 'Login'
      consumes 'application/json'
      parameter name: :user, in: :body, schema:{
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ['name']
      }

      response(200, 'successful') do
        let(:user)

        run_test!
      end
    end
  end

  path '/v1/register' do

    post('create login') do
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
  end
end
