require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:params) { { email: 'test@example.com', password: 'password' } }
    let(:service_response) { { status: 200, body: { 'token' => 'jwt-token' } } }

    it 'calls UsersApiService.login and returns its response' do
      expect(UsersApiService).to receive(:login).with(hash_including('email' => 'test@example.com'), any_args).and_return(service_response)

      post :create, params: params

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({ 'token' => 'jwt-token' })
    end
  end
end
