require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:service_response) { { status: 200, body: { 'id' => 1, 'email' => 'test@example.com' } } }

  describe 'GET #index' do
    it 'calls UsersApiService.list_users' do
      expect(UsersApiService).to receive(:list_users).and_return({ status: 200, body: [] })
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #me' do
    it 'calls UsersApiService.get_me' do
      expect(UsersApiService).to receive(:get_me).and_return(service_response)
      get :me
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(service_response[:body])
    end
  end

  describe 'GET #show' do
    it 'calls UsersApiService.get_user' do
      expect(UsersApiService).to receive(:get_user).with('1', any_args).and_return(service_response)
      get :show, params: { id: 1 }
      expect(response.status).to eq(200)
    end
  end

  describe 'PATCH #update' do
    it 'calls UsersApiService.update_user' do
      expect(UsersApiService).to receive(:update_user).with('1', hash_including('email' => 'new@example.com'), any_args).and_return(service_response)
      patch :update, params: { id: 1, email: 'new@example.com' }
      expect(response.status).to eq(200)
    end
  end

  describe 'PATCH #update_me' do
    it 'calls UsersApiService.update_me' do
      expect(UsersApiService).to receive(:update_me).with(hash_including('email' => 'new@example.com'), any_args).and_return(service_response)
      patch :update_me, params: { email: 'new@example.com' }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE #destroy' do
    it 'calls UsersApiService.delete_user' do
      expect(UsersApiService).to receive(:delete_user).with('1', any_args).and_return({ status: 204, body: nil })
      delete :destroy, params: { id: 1 }
      expect(response.status).to eq(204)
    end
  end
end
