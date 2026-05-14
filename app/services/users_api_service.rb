class UsersApiService < BaseService
  def self.base_url
    ENV["USERS_API_URL"]
  end

  def self.gateway_key
    ENV["USERS_API_GATEWAY_KEY"]
  end

  def self.register(params, headers = {})
    request(:post, "/api/v1/registration", params, headers)
  end

  def self.login(params, headers = {})
    request(:post, "/api/v1/sessions", params, headers)
  end

  def self.list_users(params = {}, headers = {})
    request(:get, "/api/v1/users", params, headers)
  end

  def self.get_me(headers = {})
    request(:get, "/api/v1/users/me", {}, headers)
  end

  def self.get_user(id, headers = {})
    request(:get, "/api/v1/users/#{id}", {}, headers)
  end

  def self.update_user(id, params, headers = {})
    request(:patch, "/api/v1/users/#{id}", params, headers)
  end

  def self.update_me(params, headers = {})
    request(:patch, "/api/v1/users/me", params, headers)
  end

  def self.delete_user(id, headers = {})
    request(:delete, "/api/v1/users/#{id}", {}, headers)
  end

  private

  def self.request(method, path, params = {}, headers = {})
    conn = connection(base_url)

    response = conn.send(method) do |req|
      req.url path
      req.headers.merge!(forward_headers(headers))
      req.headers["x-api-gateway-key"] = gateway_key if gateway_key.present?

      if [ :post, :put, :patch ].include?(method)
        req.body = params.to_json
        req.headers["Content-Type"] = "application/json"
      else
        req.params = params
      end
    end

    handle_response(response)
  rescue Faraday::Error => e
    Rails.logger.error "UsersApiService Error: #{e.message}"
    { status: 503, body: { error: "Users API service unavailable", details: e.message } }
  end
end
