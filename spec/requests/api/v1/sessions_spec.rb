require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  path '/api/v1/sessions' do
    post('User Login') do
      tags 'Sessions'
      consumes 'application/json'
      security [ x_api_gateway_key: [] ]

      let(:'x-api-gateway-key') { ENV['API_GATEWAY_KEY'] || 'test-gateway-key' }

      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'john@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'Logged in successfully') do
        let(:session) { { email: 'john@example.com', password: 'password123' } }
        before do
          allow(UsersApiService).to receive(:login).and_return({
            status: 200,
            body: {
              status: 200,
              message: 'Successfully logged in',
              data: {
                token: 'eyJhbGciOiJIUzI1NiJ9...',
                exp: '2026-05-15T12:00:00Z',
                user: { id: 1, email: 'john@example.com', role: 'user' }
              }
            }
          })
        end

        schema type: :object,
          properties: {
            status: { type: :integer, example: 200 },
            message: { type: :string, example: 'Successfully logged in' },
            data: {
              type: :object,
              properties: {
                token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9...' },
                exp: { type: :string, example: '2026-05-15T12:00:00Z' },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    email: { type: :string, example: 'john@example.com' },
                    role: { type: :string, example: 'user' }
                  }
                }
              }
            }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
        let(:session) { { email: 'john@example.com', password: 'wrong' } }
        before do
          allow(UsersApiService).to receive(:login).and_return({
            status: 401,
            body: { error: 'Invalid credentials' }
          })
        end
        run_test!
      end
    end
  end
end
