require 'swagger_helper'

RSpec.describe 'api/v1/registrations', type: :request do
  path '/api/v1/registration' do
    post('Registers a new user') do
      tags 'Registration'
      consumes 'application/json'
      security [ x_api_gateway_key: [] ]

      let(:'x-api-gateway-key') { ENV['API_GATEWAY_KEY'] || 'test-gateway-key' }

      parameter name: :registration, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'John Doe' },
          email: { type: :string, example: 'john@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: [ 'email', 'password' ]
      }

      response(201, 'Created successfully') do
        let(:registration) { { name: 'John Doe', email: 'john@example.com', password: 'password123' } }
        before do
          allow(UsersApiService).to receive(:register).and_return({
            status: 201,
            body: {
              status: 201,
              message: 'Successfully data created',
              data: {
                id: 1,
                name: 'John Doe',
                email: 'john.doe@example.com',
                role: 'user',
                created_at: Time.now.iso8601,
                updated_at: Time.now.iso8601
              }
            }
          })
        end

        schema type: :object,
          properties: {
            status: { type: :integer, example: 201 },
            message: { type: :string, example: 'Successfully data created' },
            data: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                name: { type: :string, example: 'John Doe' },
                email: { type: :string, example: 'john.doe@example.com' },
                role: { type: :string, example: 'user' },
                status: { type: :string, nullable: true },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                deleted_at: { type: :string, format: 'date-time', nullable: true }
              }
            }
          }
        run_test!
      end

      response(422, 'Validation errors') do
        let(:registration) { { email: 'invalid' } }
        before do
          allow(UsersApiService).to receive(:register).and_return({
            status: 422,
            body: { errors: { email: [ 'is invalid' ] } }
          })
        end
        run_test!
      end
    end
  end
end
