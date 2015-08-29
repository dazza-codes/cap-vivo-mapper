module Cap
  module Client

    require 'daybreak'
    require 'faraday'
    require 'faraday_middleware'

    # CAP Public Website  https://profiles.stanford.edu
    # Profiles API        https://api.stanford.edu/profiles/v1
    # Orgs API            https://api.stanford.edu/cap/v1/orgs
    # Search API          https://api.stanford.edu/cap/v1/search
    # Developer's API     https://cap.stanford.edu/cap-api/console

    class Client

      JSON_TYPE = 'application/json'

      attr_reader :config
      attr_reader :cap_api
      attr_reader :profiles

      # Initialize a new client
      def initialize
        @config = Cap::Client.configuration
        @profiles = cap_profiles_db
        # CAP API
        @cap_uri = 'https://api.stanford.edu'
        @cap_profiles = '/profiles/v1'
        @cap_orgs     = '/cap/v1/orgs'
        @cap_search   = '/cap/v1/search'
        @cap_api = Faraday.new(url: @cap_uri) do |f|
          # f.use FaradayMiddleware::FollowRedirects, limit: 3
          # f.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
          # f.request :logger, @config.logger
          f.request :json
          f.response :json, :content_type => JSON_TYPE
          f.adapter Faraday.default_adapter
        end
        @cap_api.options.timeout = 90
        @cap_api.options.open_timeout = 10
        @cap_api.headers.merge!(json_payloads)
        # Authentication
        auth_uri = 'https://authz.stanford.edu/oauth/token'
        @auth = Faraday.new(url: auth_uri) do |f|
          f.request  :url_encoded
          f.response :json, :content_type => JSON_TYPE
          f.adapter  Faraday.default_adapter
        end
        @auth.options.timeout = 30
        @auth.options.open_timeout = 10
        @auth.headers.merge!(json_payloads)
        authenticate
      ensure
        dbs = [@profiles]
        ObjectSpace.define_finalizer( self, self.class.finalize(dbs) )
      end

      def self.finalize(dbs)
        proc { dbs.each {|db| db.close} }
      end

      # Reset authentication
      def authenticate!
        @access_expiry = nil
        authenticate
      end

      def authenticate
        if @access_expiry.to_i < Time.now.to_i
          @access_code = nil
          @auth.headers.delete :Authorization
          @cap_api.headers.delete :Authorization
        end
        @access_code || begin
          return false if @config.token_user.empty? && @config.token_pass.empty?
          client = "#{@config.token_user}:#{@config.token_pass}"
          auth_code = 'Basic ' + Base64.strict_encode64(client)
          @auth.headers.merge!({ Authorization: auth_code })
          response = @auth.get "?grant_type=client_credentials"
          return false unless response.status == 200
          access = response.body
          return false if access['access_token'].nil?
          @access_code = "Bearer #{access['access_token']}"
          @access_expiry = Time.now.to_i + access['expires_in'].to_i
          @cap_api.headers[:Authorization] = @access_code
        end
      end

      # Get profiles
      # @response [json] an array of all the profile data
      def get_profiles
        begin
          if authenticate
            page = 1
            pages = 0
            profiles = 0
            begin
              while true
                params = "?p=#{page}&ps=100"
                response = @cap_api.get "#{@cap_profiles}#{params}"
                if response.status == 200
                  data = response.body
                  if data['firstPage']
                    pages = data['totalPages']
                    profiles = data['totalCount']
                    puts "Retrieved #{page} of #{pages} pages (#{profiles} profiles)."
                  else
                    puts "Retrieved #{page} of #{pages} pages."
                  end
                  data['values'].each do |profile|
                    id = profile["profileId"]
                    @profiles[id] = profile
                  end
                  @profiles.flush
                  page += 1
                  break if data['lastPage']
                else
                  msg = "Failed to GET profiles page #{page}: #{response.status}"
                  @config.logger.error msg
                  puts msg
                  break
                end
              end
            rescue => e
              msg = e.message
              binding.pry if @config.debug
              @config.logger.error msg
            ensure
              @profiles.flush
              @profiles.compact
              @profiles.load
              puts "Stored #{@profiles.size} of #{profiles} profiles."
              puts "Stored profiles to #{@profiles.class} at: #{@profiles.file}."
            end
          else
            msg = "Failed to authenticate"
            @config.logger.error msg
          end
        rescue => e
          msg = e.message
          binding.pry if @config.debug
          @config.logger.error(msg)
        end
      end

      private

      def cap_profiles_db
        dir = File.dirname(@config.log_file)
        db = Daybreak::DB.new File.join(dir,'cap_profiles.db')
        db.load if db.size > 0
        db
      end

      def json_payloads
        { accept: JSON_TYPE, content_type: JSON_TYPE }
      end

    end
  end
end
