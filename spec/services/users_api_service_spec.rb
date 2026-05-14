require 'rails_helper'

RSpec.describe UsersApiService do
  let(:base_url) { ENV['USERS_API_URL'] || 'http://localhost:3001' }
  let(:gateway_key) { ENV['USERS_API_GATEWAY_KEY'] || 'test-key' }

  before do
    stub_const('ENV', ENV.to_h.merge('USERS_API_URL' => base_url, 'USERS_API_GATEWAY_KEY' => gateway_key))
  end

  describe 'API methods' do
    let(:headers) { { 'Authorization' => 'Bearer token' } }
    let(:params) { { 'email' => 'test@example.com' } }
    let(:success_body) { { 'status' => 'success' }.to_json }

    it '.register' do
      stub_request(:post, "#{base_url}/api/v1/registration")
        .with(body: params.to_json, headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 201, body: success_body)

      response = UsersApiService.register(params, headers)
      expect(response[:status]).to eq(201)
      expect(response[:body]).to eq(JSON.parse(success_body))
    end

    it '.login' do
      stub_request(:post, "#{base_url}/api/v1/sessions")
        .with(body: params.to_json, headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 200, body: success_body)

      response = UsersApiService.login(params, headers)
      expect(response[:status]).to eq(200)
    end

    it '.list_users' do
      stub_request(:get, "#{base_url}/api/v1/users")
        .with(query: params, headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 200, body: success_body)

      response = UsersApiService.list_users(params, headers)
      expect(response[:status]).to eq(200)
    end

    it '.get_me' do
      stub_request(:get, "#{base_url}/api/v1/users/me")
        .with(headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 200, body: success_body)

      response = UsersApiService.get_me(headers)
      expect(response[:status]).to eq(200)
    end

    it '.get_user' do
      stub_request(:get, "#{base_url}/api/v1/users/1")
        .with(headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 200, body: success_body)

      response = UsersApiService.get_user(1, headers)
      expect(response[:status]).to eq(200)
    end

    it '.update_user' do
      stub_request(:patch, "#{base_url}/api/v1/users/1")
        .with(body: params.to_json, headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 200, body: success_body)

      response = UsersApiService.update_user(1, params, headers)
      expect(response[:status]).to eq(200)
    end

    it '.update_me' do
      stub_request(:patch, "#{base_url}/api/v1/users/me")
        .with(body: params.to_json, headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 200, body: success_body)

      response = UsersApiService.update_me(params, headers)
      expect(response[:status]).to eq(200)
    end

    it '.delete_user' do
      stub_request(:delete, "#{base_url}/api/v1/users/1")
        .with(headers: { 'Authorization' => 'Bearer token', 'x-api-gateway-key' => gateway_key })
        .to_return(status: 204)

      response = UsersApiService.delete_user(1, headers)
      expect(response[:status]).to eq(204)
    end
  end

  describe 'error handling' do
    it 'handles Faraday::Error' do
      stub_request(:get, /.*/).to_raise(Faraday::Error.new('Connection failed'))

      response = UsersApiService.list_users
      expect(response[:status]).to eq(503)
      expect(response[:body][:error]).to eq('Users API service unavailable')
    end
  end
end
