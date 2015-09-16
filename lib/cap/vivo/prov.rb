module Cap
  module Vivo
    module Prov

      # PROV data
      MAPPING_ENTITY = RDF::URI.parse('https://github.com/sul-dlss/cap-vivo-mapper')
      MAPPING_ACTIVITY = RDF::URI.parse('https://github.com/sul-dlss/cap-vivo-mapper/mapping')

      # MAPPING_AGENT = RDF::URI.parse('http://orcid.org/0000-0002-4822-6661')
      MAPPING_AGENT = RDF::URI.parse('http://www.linkedin.com/in/darrenleeweber')
      MAPPING_AGENT_NAME = RDF::Literal.new('Darren Lee Weber, Ph.D.')

      MAPPING_ORG = RDF::URI.parse('http://library.stanford.edu')
      MAPPING_ORG_NAME = RDF::Literal.new('Stanford Univerity Libraries')

      # Add provenance information to a Vivo profile derived from a CAP profile.
      # @param rdf [RDF::Graph]  graph without PROV
      # @param vivo_uri [RDF::URI]
      # @param cap_uri [RDF::URI]
      # @param cap_modified [String|] profile['lastModified']
      # @return rdf [RDF::Graph]  graph with PROV
      def prov_profile(rdf, vivo_uri, cap_uri, cap_modified)
        cap_modified = time_modified(cap_modified)
        vivo_modified = time_modified
        prov_mapping  # create most of the PROV once
        rdf << [vivo_uri, RDF.type, RDF::PROV.Entity]
        rdf << [cap_uri,  RDF.type, RDF::PROV.Entity]
        rdf << [cap_uri,  RDF::PROV.generatedAtTime, cap_modified]
        rdf << [vivo_uri, RDF::PROV.wasDerivedFrom, cap_uri]
        rdf << [vivo_uri, RDF::PROV.wasGeneratedBy, MAPPING_ACTIVITY]
        rdf << [vivo_uri,  RDF::PROV.generatedAtTime, vivo_modified]
        rdf << [MAPPING_ACTIVITY, RDF::PROV.used, cap_uri]
        rdf
      end

      # Save the PROV mapping activity and associated agent data to the
      # triple store once.
      def prov_mapping
        @@prov_mapping ||= begin
          g = RDF::Graph.new
          g << [MAPPING_ENTITY, RDF.type, RDF::PROV.Entity]
          g << [MAPPING_ACTIVITY, RDF.type, RDF::PROV.Activity]
          g << [MAPPING_ACTIVITY, RDF::PROV.wasAssociatedWith, MAPPING_AGENT]
          g << [MAPPING_AGENT, RDF.type, RDF::PROV.Agent]
          g << [MAPPING_AGENT, RDF.type, RDF::PROV.Person]
          g << [MAPPING_AGENT, RDF::FOAF.name, MAPPING_AGENT_NAME]
          g << [MAPPING_AGENT, RDF::PROV.actedOnBehalfOf, MAPPING_ORG]
          g << [MAPPING_ORG, RDF.type, RDF::PROV.Agent]
          g << [MAPPING_ORG, RDF.type, RDF::PROV.Organization]
          g << [MAPPING_ORG, RDF::FOAF.name, MAPPING_ORG_NAME]
          g.each_statement do |s|
            Cap::Vivo.configuration.rdf_repo.insert_statement s
          end
          true
        rescue => e
          Cap::Vivo.configuration.logger.error e.message
          false
        end
      end

      # Generate or parse a datetime
      # @param date [String|Time|Date|DateTime] optional date time value
      # @return date [RDF::Literal] an XSD.dateTime in UTC
      def time_modified(t=nil)
        if t.nil?
          t = DateTime.now.new_offset(0)
        elsif t.is_a? String
          t = DateTime.parse(t).new_offset(0)
        elsif t.is_a? Time
          t = t.utc
        elsif t.is_a? Date
          t = t.to_datetime.new_offset(0)
        elsif t.is_a? DateTime
          t = t.new_offset(0)
        end
        RDF::Literal.new(t, :datatype => RDF::XSD.dateTime)
      end

    end
  end
end
