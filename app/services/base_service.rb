class BaseService
  def self.connection(url)
    Faraday.new(url: url) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.handle_response(response)
    {
      status: response.status,
      body: begin
              JSON.parse(response.body)
            rescue JSON::ParserError
              response.body
            end
    }
  rescue StandardError => e
    Rails.logger.error "Service Error: #{e.message}"
    { status: 500, body: { error: "Service error", details: e.message } }
  end

  def self.forward_headers(request_headers)
    headers = {}
    headers["Authorization"] = request_headers["Authorization"] if request_headers["Authorization"].present?
    # Add other headers to forward if necessary
    headers
  end
end
