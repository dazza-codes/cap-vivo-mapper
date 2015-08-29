require 'dotenv'
Dotenv.load

require_relative 'client/configuration'
require_relative 'client/cap_client'

# This is a utility working with Stanford CAP.
# https://github.com/sul-dlss/cap-vivo-mapper
module Cap
  module Client

    # Configuration at the module level, see
    # http://brandonhilkert.com/blog/ruby-gem-configuration-patterns/
    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end

  end
end
