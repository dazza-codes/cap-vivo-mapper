module Cap
  module Vivo
    module GraphUtils

      # Create RDF::Graph from a data hash with a jsonld context
      # @param data [Hash] a hash with a jsonld context
      # @return graph [RDF::Graph]
      def from_jsonld(data, context=nil)
        data.merge!(context) if context
        RDF::Graph.new << JSON::LD::API.toRdf(data)
      end

      # Serialize RDF::Graph as jsonld
      # @param rdf [RDF::Graph]
      # @return jsonld [String] the result of rdf.dump(:jsonld)
      def to_jsonld(rdf)
        rdf.dump(:jsonld, standard_prefixes: true)
      end

    end
  end
end
