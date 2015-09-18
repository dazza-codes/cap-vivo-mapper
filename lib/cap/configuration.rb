module Cap

  class Configuration

    attr_accessor :debug
    attr_accessor :logger
    attr_reader :log_file

    attr_reader :cap_repo
    attr_reader :cap_replace

    attr_reader :rdf_path
    attr_reader :rdf_repo
    attr_reader :rdf_replace

    def initialize
      self.debug = env_boolean('DEBUG')
      logger_init
      cap_repo
      @cap_replace = env_boolean('CAP_API_REPLACE')
      rdf_repo
      @rdf_replace = env_boolean('CAP_RDF_REPLACE')
      rdf_path
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
      path = ENV['CAP_REPO_PATH'] || './vivo_rdf'
      @rdf_path = File.absolute_path(path)
      FileUtils.mkdir_p @rdf_path
    end

    # Create an RDF::FourStore::Repository for storing VIVO RDF data
    # ENV['CAP_REPO_4STORE'] || 'http://localhost:9001'
    def rdf_repo
      @rdf_repo ||= begin
        repo = ENV['CAP_REPO_4STORE'].dup || 'http://localhost:9001'
        RDF::FourStore::Repository.new(repo)
      end
    end

    # Create a repository for storing CAP API json data
    # Uses mongodb if ENV['CAP_REPO_MONGO'], otherwise Daybreak::DB
    def cap_repo
      @cap_repo ||= begin
        if ENV['CAP_REPO_MONGO']
          cap_repo_mongo
        else
          cap_repo_daybreak
        end
      end
    end

    # Create an repository for storing CAP API json data
    # Uses Daybreak::DB in log/cap_profiles.db
    def cap_repo_daybreak
      @cap_repo_daybreak ||= begin
        dir = File.dirname(@log_file)
        db = Daybreak::DB.new File.join(dir,'cap_profiles.db')
        db.load if db.size > 0
        db
      end
    end

    # Create a repository for storing CAP API json data
    # ENV['CAP_REPO_MONGO'] || 'mongodb://127.0.0.1:27017/cap'
    def cap_repo_mongo
      @cap_repo_mongo ||= begin
        dir = File.dirname(@log_file)
        log_file = File.join(dir,'cap_repo_mongo.log')
        log_dev = File.new(log_file, 'w+')
        log_dev.sync = true if @debug # skip IO buffering in debug mode
        logger = Logger.new(log_dev, 'weekly')
        logger.level = @debug ? Logger::INFO : Logger::WARN
        Mongo::Logger.logger = logger
        repo = ENV['CAP_REPO_MONGO'].dup || 'mongodb://127.0.0.1:27017/cap'
        Mongo::Client.new(repo)
      end
    end

  end
end
