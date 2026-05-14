require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  let(:user_data) { { id: 1, name: 'Alice', email: 'alice@example.com', role: 'user' } }
  let(:'x-api-gateway-key') { ENV['API_GATEWAY_KEY'] || 'test-gateway-key' }
  let(:Authorization) { 'Bearer test-token' }

  path '/api/v1/users' do
    get('Retrieves paginated users list') do
      tags 'Users'
      security [ bearer_auth: [], x_api_gateway_key: [] ]
      parameter name: :role, in: :query, type: :string, required: false
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response(200, 'Users fetched successfully') do
        before do
          allow(UsersApiService).to receive(:list_users).and_return({
            status: 200,
            body: { status: 200, message: 'Successfully data fetched', data: [ user_data ] }
          })
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/me' do
    get('Retrieves current logged in user details') do
      tags 'Users'
      security [ bearer_auth: [], x_api_gateway_key: [] ]

      response(200, 'User details fetched successfully') do
        before do
          allow(UsersApiService).to receive(:get_me).and_return({
            status: 200,
            body: { status: 200, message: 'Successfully data fetched', data: user_data }
          })
        end
        run_test!
      end
    end

    patch('Updates current logged in user details') do
      tags 'Users'
      consumes 'application/json'
      security [ bearer_auth: [], x_api_gateway_key: [] ]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Jane Doe' },
              email: { type: :string, example: 'jane@example.com' },
              status: { type: :string, example: 'active' }
            }
          }
        }
      }

      response(200, 'User updated successfully') do
        let(:user) { { user: { name: 'Jane Doe' } } }
        before do
          allow(UsersApiService).to receive(:update_me).and_return({
            status: 200,
            body: { status: 200, message: 'Successfully data updated', data: user_data.merge(name: 'Jane Doe') }
          })
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'User ID'

    get('Retrieves a user') do
      tags 'Users'
      security [ bearer_auth: [], x_api_gateway_key: [] ]

      response(200, 'User fetched successfully') do
        let(:id) { '1' }
        before do
          allow(UsersApiService).to receive(:get_user).and_return({
            status: 200,
            body: { status: 200, message: 'Successfully data fetched', data: user_data }
          })
        end
        run_test!
      end

      response(404, 'User not found') do
        let(:id) { 'nonexistent' }
        before do
          allow(UsersApiService).to receive(:get_user).and_return({
            status: 404,
            body: { error: 'User not found' }
          })
        end
        run_test!
      end
    end

    patch('Updates a user') do
      tags 'Users'
      consumes 'application/json'
      security [ bearer_auth: [], x_api_gateway_key: [] ]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Jane Doe' },
              email: { type: :string, example: 'jane@example.com' },
              status: { type: :string, example: 'active' }
            }
          }
        }
      }

      response(200, 'User updated successfully') do
        let(:id) { '1' }
        let(:user) { { user: { name: 'Jane Doe' } } }
        before do
          allow(UsersApiService).to receive(:update_user).and_return({
            status: 200,
            body: { status: 200, message: 'Successfully data updated', data: user_data.merge(name: 'Jane Doe') }
          })
        end
        run_test!
      end
    end

    delete('Deletes a user') do
      tags 'Users'
      security [ bearer_auth: [], x_api_gateway_key: [] ]

      response(200, 'User deleted successfully') do
        let(:id) { '1' }
        before do
          allow(UsersApiService).to receive(:delete_user).and_return({
            status: 200,
            body: { status: 200, message: 'Successfully data deleted' }
          })
        end
        run_test!
      end
    end
  end
end
