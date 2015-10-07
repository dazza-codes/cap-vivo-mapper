require 'dotenv'
Dotenv.load

require 'time'
require 'linkeddata'
require 'rdf/4store'
require 'mongo'
require_relative 'cap/configuration'
require_relative 'rdf/vocab/vivo.rb'
require_relative 'rdf/vocab/vivo_vcard.rb'

# This is a utility working with Stanford CAP and VIVO data mappings.
# https://github.com/sul-dlss/cap-vivo-mapper
module Cap

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
