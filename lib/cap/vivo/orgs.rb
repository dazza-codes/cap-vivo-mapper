module Cap
  module Vivo
    module Orgs

      HAS_CONTACT_INFO = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000028'

      def org_strings2things(org)
        case org
        when 'Stanford Medical School'
          stanford_medical_school
        end
      end

      def stanford_medical_school
        @@stanford_medical_school ||= begin
            org_uri = RDF::URI.parse('http://med.stanford.edu')
            g = RDF::Graph.new
            g << [org_uri, RDF.type, RDF::FOAF.Organization]
            g << [org_uri, RDF.type, RDF::VIVO.School]
            vcard = org_uri + '/vcard'
            g << [org_uri, HAS_CONTACT_INFO, vcard]
            g << [vcard, RDF.type, RDF::Vocab::VCARD.Organization]

            vcard_name = vcard + "/name"
            g << [vcard, RDF::Vocab::VCARD.hasName, vcard_name]
            g << [vcard_name, RDF.type, RDF::Vocab::VCARD.Name]
            g << [vcard_name, RDF::RDFS.label, type]
            g << [vcard_name, RDF::Vocab::VCARD.send('given-name'), fn]
            g << [vcard_name, RDF::Vocab::VCARD.send('family-name'), ln]
            #     vcard:hasName [
            #         a vcard:Name;
            #         vcard:givenName "Stanford Medical School"@en.

            #     vcard:hasAddress [
            #         a vcard:Address, vcard:Work;
            #         vcard:country-name "United States";
            #         vcard:region "California";
            #         vcard:locality "Stanford";
            #         vcard:postal-code "94305";
            #         vcard:street-address "Medical School, Stanford" .

            #     vcard:hasTelephone [
            #         a vcard:Telephone, vcard:Work, vcard:Voice;
            #         vcard:telephone <tel:+6509999999> .

            #     vcard:hasURL [
            #         a vcard:URL;
            #         rdfs:label "Stanford Website"@en;
            #         vcard:url "http://www.stanford.edu" .

            #         a vcard:URL;
            #         rdfs:label "Stanford Medical School Website"@en;
            #         vcard:url "http://smi.stanford.edu" .

            #     # TODO: use vivo:Campus ????
            #     # TODO: Associate school of medicine with Stanford U ????
            g
        end
      end


      # MAPPING_ORG = RDF::URI.parse('http://library.stanford.edu')
      # MAPPING_ORG_NAME = RDF::Literal.new('Stanford Univerity Libraries')

    end
  end
end
