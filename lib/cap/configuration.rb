module Cap

  class Configuration

    attr_accessor :debug
    attr_accessor :logger
    attr_reader :log_file

    attr_reader :cap_replace
    attr_reader :cap_testing

    attr_reader :rdf_path
    attr_reader :rdf_repo
    attr_reader :rdf_replace
    attr_reader :rdf_prov

    def initialize
      self.debug = env_boolean('DEBUG')
      logger_init
      @cap_testing = env_boolean('CAP_TESTING')
      @cap_replace = env_boolean('CAP_API_REPLACE')
      @rdf_replace = env_boolean('CAP_RDF_REPLACE')
      @rdf_prov = env_boolean('CAP_RDF_PROV')
      rdf_path
      rdf_repo
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
        log_file = ENV['CAP_LOG_FILE'] || 'log/cap.log'
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

    # Create an output path for storing VIVO RDF data
    # ENV['CAP_REPO_PATH'] || './vivo_rdf'
    def rdf_path
      @rdf_path ||= begin
        path = ENV['CAP_REPO_PATH'] || './data/vivo_rdf'
        path = File.absolute_path(path)
        FileUtils.mkdir_p path
        path
      end
    end

    # Create an RDF::FourStore::Repository for storing VIVO RDF data
    # ENV['CAP_REPO_4STORE'] || 'http://localhost:9001'
    def rdf_repo
      @rdf_repo ||= begin
        if ENV['CAP_REPO_4STORE']
          repo_uri = ENV['CAP_REPO_4STORE'].dup
        else
          repo_uri = 'http://localhost:9001'
        end
        RDF::FourStore::Repository.new(repo_uri)
      end
    end

  end
end
