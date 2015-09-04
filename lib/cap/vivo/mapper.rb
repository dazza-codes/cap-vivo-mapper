module Cap
  module Vivo

    class Mapper

      HAS_CONTACT_INFO = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000028'

      PROFILE_URI_PREFIX = 'https://profiles.stanford.edu/vivo'

      attr_accessor :config

      # profile
      attr_accessor :profile
      attr_reader :id
      attr_reader :uri
      attr_reader :rdf

      # @param profile [JSON] CAP API profile - json object
      def initialize(profile)
        @config = Cap::Vivo.configuration
        @profile = profile
        @id = profile['profileId']
        @uri = RDF::URI.parse "#{PROFILE_URI_PREFIX}/#{@id}"
        @rdf = RDF::Graph.new
        @rdf << [@uri, RDF.type, RDF::FOAF.Person]
      end

      # Convert CAP profile into VIVO linked data
      def create_vivo
        create_vcard
      end

      # Map names, addresses, contacts and web links to vcard data.
      def create_vcard
        vcard = RDF::Node.new
        @rdf << [@uri, HAS_CONTACT_INFO, vcard]
        @rdf << [vcard, RDF.type, RDF::Vocab::VCARD.Individual]
        # Names
        profile['names'].each_pair do |type, name|
          given_name  = name['firstName']
          family_name = name['lastName']
          vcard_name = RDF::Node.new
          @rdf << [vcard, RDF::Vocab::VCARD.hasName, vcard_name]
          @rdf << [vcard_name, RDF.type, RDF::Vocab::VCARD.Name]
          @rdf << [vcard_name, RDF::RDFS.label, type]
          @rdf << [vcard_name, RDF::Vocab::VCARD.send('given-name'), given_name]
          @rdf << [vcard_name, RDF::Vocab::VCARD.send('family-name'), family_name]
        end
        # Addresses
        offices = profile['academicOffices'] || []
        offices.each do |office|
          vcard_address = RDF::Node.new
          @rdf << [vcard, RDF::Vocab::VCARD.hasAddress, vcard_address]
          @rdf << [vcard_address, RDF.type, RDF::Vocab::VCARD.Address]
          @rdf << [vcard_address, RDF.type, RDF::Vocab::VCARD.Work]
          @rdf << [vcard_address, RDF::RDFS.label, office['type']]
          country = office['country'] || 'United States'
          @rdf << [vcard_address, RDF::Vocab::VCARD.send('country-name'), country]
          @rdf << [vcard_address, RDF::Vocab::VCARD.region, office['state']]
          @rdf << [vcard_address, RDF::Vocab::VCARD.locality, office['city']]
          @rdf << [vcard_address, RDF::Vocab::VCARD.send('postal-code'), office['zip']]
          @rdf << [vcard_address, RDF::Vocab::VCARD.send('street-address'), office['address']]
        end
        # Contacts (email and telephone)
        contacts = []
        contacts.push profile['primaryContact']
        contacts.push profile['alternateContact']
        contacts.compact!
        contacts.each do |contact|
          unless contact['email'].nil?
            email = RDF::URI.parse("mailto:#{contact['email']}")
            label = contact['type'] || contact['label'] || ''
            vcard_email = RDF::Node.new
            @rdf << [vcard, RDF::Vocab::VCARD.hasEmail, vcard_email]
            @rdf << [vcard_email, RDF.type, RDF::Vocab::VCARD.Email]
            @rdf << [vcard_email, RDF.type, RDF::Vocab::VCARD.Work]
            @rdf << [vcard_email, RDF::Vocab::VCARD.hasValue, email]
            @rdf << [vcard_email, RDF::RDFS.label, label]
          end
          phone_numbers = contact['phoneNumbers'] || []
          phone_numbers.each do |phone|
            number = phone.gsub(/\s+|[()+-]/,'')
            tel = "tel:#{number}"
            vcard_phone = RDF::Node.new
            @rdf << [vcard, RDF::Vocab::VCARD.hasTelephone, vcard_phone]
            @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Tel]
            @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Voice]
            @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Work]
            @rdf << [vcard_phone, RDF::Vocab::VCARD.hasValue, tel]
          end
        end
        # Web Links
        profile['meta']['links'].each do |link|
          if link['rel'] == 'https://cap.stanford.edu/rel/public'
            url = RDF::URI.parse link['href']
            vcard_url = RDF::Node.new
            @rdf << [vcard, RDF::Vocab::VCARD.hasURL, vcard_url]
            @rdf << [vcard_url, RDF::Vocab::VCARD.hasValue, url]
            @rdf << [vcard_url, RDF::RDFS.label, "CAP public profile"]
            @rdf << [vcard_url, RDF.type, RDF::Vocab::VCARD.Work]
          end
        end
      end

      def save
        @rdf.each_statement {|s| @config.rdf_repo.insert_statement s};
      end

      def prov
        now = RDF::Literal.new(Time.now.utc, :datatype => RDF::XSD.dateTime)
      end

      def to_jsonld
        @rdf.dump(:jsonld, standard_prefixes: true)
      end

      def to_ttl
        @rdf.to_ttl
      end

    end
  end
end
