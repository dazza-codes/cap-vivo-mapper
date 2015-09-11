module Cap
  module Client

    class Configuration

      attr_accessor :debug
      attr_accessor :logger
      attr_reader :log_file

      # Parameters for authentication
      attr_accessor :token_user
      attr_accessor :token_pass

      # Remove any privileged information from CAP profile data?
      attr_accessor :clean

      def initialize
        self.debug = env_boolean('DEBUG')
        logger_init
        # Parameters for triannon client authentication
        @token_user = ENV['CAP_TOKEN_USER'] || ''
        @token_pass = ENV['CAP_TOKEN_PASS'] || ''
        # Remove any privileged information from CAP profile data?
        @clean = env_boolean('CAP_API_CLEAN')
      end

      def env_boolean(var)
        # check if an ENV variable is true, use false as default
        ENV[var].to_s.upcase == 'TRUE' rescue false
      end

      def debug=(bool)
        raise ArgumentError unless [true, false].include?(bool)
        @debug = bool
        if @debug
          # pry must be available when the library is run in debug mode.
          require 'pry'
          require 'pry-doc'
        end
      end

      def logger_init
        require 'logger'
        begin
          log_file = ENV['CAP_CLIENT_LOG_FILE'] || 'log/cap_client.log'
          @log_file = File.absolute_path log_file
          FileUtils.mkdir_p File.dirname(@log_file) rescue nil
          log_dev = File.new(@log_file, 'w+')
        rescue
          log_dev = $stderr
          @log_file = 'STDERR'
        end
        log_dev.sync = true if @debug # skip IO buffering in debug mode
        @logger = Logger.new(log_dev, 'weekly')
        @logger.level = @debug ? Logger::DEBUG : Logger::INFO
      end

    end
  end
end
