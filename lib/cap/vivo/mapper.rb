require 'dotenv'
Dotenv.load

require 'cap/vivo/mapper/version'
require_relative 'mapper/configuration'

# This is a utility working with Stanford CAP and VIVO data mappings.
# https://github.com/sul-dlss/cap-vivo-mapper
module Cap
  module Vivo
    module Mapper

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
end
