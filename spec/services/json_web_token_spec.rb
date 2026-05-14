require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:user_id) { 1 }
  let(:payload) { { user_id: user_id } }

  describe '.encode' do
    it 'encodes the payload into a JWT' do
      token = described_class.encode(payload)
      expect(token).to be_a(String)
      expect(token.split('.').size).to eq(3)
    end

    it 'includes an expiration time' do
      token = described_class.encode(payload)
      decoded = JWT.decode(token, described_class::SECRET_KEY)[0]
      expect(decoded).to have_key('exp')
    end
  end

  describe '.decode' do
    let(:token) { described_class.encode(payload) }

    it 'decodes a valid token' do
      decoded = described_class.decode(token)
      expect(decoded[:user_id]).to eq(user_id)
    end

    it 'returns nil for an invalid token' do
      expect(described_class.decode('invalid-token')).to be_nil
    end

    it 'returns nil for an expired token' do
      expired_token = described_class.encode(payload, 1.hour.ago)
      expect(described_class.decode(expired_token)).to be_nil
    end
  end
end
