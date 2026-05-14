require 'rails_helper'

RSpec.describe BaseService do
  describe '.connection' do
    let(:url) { 'http://example.com' }

    it 'returns a Faraday connection' do
      conn = BaseService.connection(url)
      expect(conn).to be_a(Faraday::Connection)
      expect(conn.url_prefix.to_s).to eq('http://example.com/')
    end
  end

  describe '.handle_response' do
    let(:response) { double('Faraday::Response', status: 200, body: '{"key": "value"}') }

    it 'parses JSON body' do
      result = BaseService.handle_response(response)
      expect(result[:status]).to eq(200)
      expect(result[:body]).to eq({ 'key' => 'value' })
    end

    context 'when body is not JSON' do
      let(:response) { double('Faraday::Response', status: 200, body: 'Not JSON') }

      it 'returns raw body' do
        result = BaseService.handle_response(response)
        expect(result[:body]).to eq('Not JSON')
      end
    end

    context 'when an error occurs' do
      it 'handles StandardError' do
        allow(JSON).to receive(:parse).and_raise(StandardError.new('Something went wrong'))
        result = BaseService.handle_response(response)
        expect(result[:status]).to eq(500)
        expect(result[:body][:error]).to eq('Service error')
        expect(result[:body][:details]).to eq('Something went wrong')
      end
    end
  end

  describe '.forward_headers' do
    let(:request_headers) { { 'Authorization' => 'Bearer token', 'Other' => 'Value' } }

    it 'forwards only Authorization header' do
      result = BaseService.forward_headers(request_headers)
      expect(result).to eq({ 'Authorization' => 'Bearer token' })
    end

    context 'when Authorization header is missing' do
      let(:request_headers) { { 'Other' => 'Value' } }

      it 'returns an empty hash' do
        result = BaseService.forward_headers(request_headers)
        expect(result).to eq({})
      end
    end
  end
end
