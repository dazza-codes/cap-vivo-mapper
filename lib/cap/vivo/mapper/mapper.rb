module Cap
  module Vivo
    module Mapper

      class Mapper

        attr_accessor :config

        def initialize
          @config = Cap::Vivo::Mapper.configuration
        end

      end
    end
  end
end
