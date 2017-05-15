module Vivo

  require 'faraday'
  require 'faraday_middleware'

  # A ruby client for the VIVO API, see
  # https://wiki.duraspace.org/display/VIVO/The+VIVO+APIs
  class Client

    JSON_CONTENT = 'application/json'

    attr_reader :config
    attr_reader :vivo_api
    # attr_reader :profiles

    # Initialize a new client
    def initialize
      @config = Vivo::Client.configuration
      # VIVO API
      @vivo_uri = 'https://api.stanford.edu'
      @vivo_api = Faraday.new(url: @vivo_uri) do |f|
        # f.use FaradayMiddleware::FollowRedirects, limit: 3
        # f.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
        # f.request :logger, @config.logger
        f.request :json
        f.response :json, :content_type => JSON_CONTENT
        f.adapter Faraday.default_adapter
      end
      @vivo_api.options.timeout = 90
      @vivo_api.options.open_timeout = 10
      @vivo_api.headers.merge!(json_payloads)
      # # Authentication
      # auth_uri = 'https://authz.stanford.edu/oauth/token'
      # @auth = Faraday.new(url: auth_uri) do |f|
      #   f.request  :url_encoded
      #   f.response :json, :content_type => JSON_CONTENT
      #   f.adapter  Faraday.default_adapter
      # end
      # @auth.options.timeout = 30
      # @auth.options.open_timeout = 10
      # @auth.headers.merge!(json_payloads)
    end

    # # Reset authentication
    # def authenticate!
    #   @access_expiry = nil
    #   authenticate
    # end

    # def authenticate
    #   if @access_expiry.to_i < Time.now.to_i
    #     @access_code = nil
    #     @auth.headers.delete :Authorization
    #     @vivo_api.headers.delete :Authorization
    #   end
    #   @access_code || begin
    #     return false if @config.token_user.empty? && @config.token_pass.empty?
    #     client = "#{@config.token_user}:#{@config.token_pass}"
    #     auth_code = 'Basic ' + Base64.strict_encode64(client)
    #     @auth.headers.merge!({ Authorization: auth_code })
    #     response = @auth.get "?grant_type=client_credentials"
    #     return false unless response.status == 200
    #     access = response.body
    #     return false if access['access_token'].nil?
    #     @access_code = "Bearer #{access['access_token']}"
    #     @access_expiry = Time.now.to_i + access['expires_in'].to_i
    #     @vivo_api.headers[:Authorization] = @access_code
    #   end
    # end

    private

    def json_payloads
      { accept: JSON_CONTENT, content_type: JSON_CONTENT }
    end

  end
end
