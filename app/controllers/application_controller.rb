class ApplicationController < ActionController::API
  before_action :verify_api_gateway_key

  attr_reader :current_user

  rescue_from StandardError, with: :handle_exception

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  private


  def handle_exception(exception)
    logger.error exception.message
    logger.error exception.backtrace.join "\n"
    render_json_response(:internal_server_error, exception.message)
  end

  def render_json_response(status, message = "", data = nil, extra = {})
    status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
    response = {
      status: status,
      message: message,
      data: data
    }.merge(extra)
    render json: response, status: status
  end

  def pagination_info
    {
      page: (params[:page].presence || DEFAULT_PAGE).to_i,
      per_page: (params[:per_page].presence || DEFAULT_PER_PAGE).to_i
    }
  end


  def verify_api_gateway_key
    expected_key = ENV["API_GATEWAY_KEY"]
    return if expected_key.blank?

    provided_key = request.headers["x-api-gateway-key"]

    if provided_key != expected_key
      render_json_response(:forbidden, "Invalid API Gateway Key")
    end
  end


  def cast_boolean(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
