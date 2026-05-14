require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe 'POST #create' do
    let(:params) { { email: 'test@example.com', password: 'password' } }
    let(:service_response) { { status: 201, body: { 'message' => 'User created' } } }

    it 'calls UsersApiService.register and returns its response' do
      expect(UsersApiService).to receive(:register).with(hash_including('email' => 'test@example.com'), any_args).and_return(service_response)

      post :create, params: params

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)).to eq({ 'message' => 'User created' })
    end
  end
end
