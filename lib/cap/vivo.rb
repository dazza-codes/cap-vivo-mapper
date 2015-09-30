require 'dotenv'
Dotenv.load

require 'linkeddata'
require 'rdf/4store'
require_relative 'vivo/version'
require_relative 'vivo/graph_utils'
require_relative 'vivo/vivo_terms'
require_relative 'vivo/configuration'
require_relative 'vivo/degrees'
require_relative 'vivo/orgs'
require_relative 'vivo/prov'
require_relative 'vivo/mapper'
require_relative 'vivo/profile'

# This is a utility working with Stanford CAP and VIVO data mappings.
# https://github.com/sul-dlss/cap-vivo-mapper
module Cap
  module Vivo

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
