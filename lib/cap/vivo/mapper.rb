module Cap
  module Vivo

    class Mapper

      HAS_CONTACT_INFO = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000028'

      PROFILE_URI_PREFIX = RDF::URI.parse 'https://profiles.stanford.edu/vivo'

      # PROV data
      MAPPING_ACTIVITY = RDF::URI.parse('https://github.com/sul-dlss/cap-vivo-mapper/mapping')
      MAPPING_ENTITY = RDF::URI.parse('https://github.com/sul-dlss/cap-vivo-mapper')
      # MAPPING_AGENT = RDF::URI.parse('http://orcid.org/0000-0002-4822-6661')
      MAPPING_AGENT = RDF::URI.parse('http://www.linkedin.com/in/darrenleeweber')
      MAPPING_ORG = RDF::URI.parse('http://library.stanford.edu')
      MAPPING_AGENT_NAME = RDF::Literal.new('Darren Lee Weber, Ph.D.')
      MAPPING_ORG_NAME = RDF::Literal.new('Stanford Univerity Libraries')

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
        @uri = PROFILE_URI_PREFIX + "/#{@id}"
        @rdf = RDF::Graph.new
        @rdf << [@uri, RDF.type, RDF::FOAF.Person]
      end

      # Convert CAP profile into VIVO linked data
      def create_vivo
        create_vcard
        prov
      end

      # Map names, addresses, contacts and web links to vcard data.
      def create_vcard
        vcard = @uri + '/vcard'
        @rdf << [@uri, HAS_CONTACT_INFO, vcard]
        @rdf << [vcard, RDF.type, RDF::Vocab::VCARD.Individual]
        # Names
        profile['names'].each_pair do |type, name|
          fn = name['firstName'] || ''
          mn = name['middleName'] || ''
          ln = name['lastName'] || ''
          vcard_name = vcard + "/names/#{type}"
          @rdf << [vcard, RDF::Vocab::VCARD.hasName, vcard_name]
          @rdf << [vcard_name, RDF.type, RDF::Vocab::VCARD.Name]
          @rdf << [vcard_name, RDF::RDFS.label, type]
          @rdf << [vcard_name, RDF::Vocab::VCARD.send('given-name'), fn]
          @rdf << [vcard_name, RDF::Vocab::VCARD.send('family-name'), ln]
          unless mn.empty?
            @rdf << [vcard_name, RDF::Vocab::VCARD.send('additional-name'), mn]
          end
        end
        # Addresses
        offices = profile['academicOffices'] || []
        offices.each do |office|
          type = offices.length > 1 ? SecureRandom.hex(5) : office['type']
          label = office['label'] || office['officeName']
          vcard_address = vcard + "/academicOffices/#{type}"
          @rdf << [vcard, RDF::Vocab::VCARD.hasAddress, vcard_address]
          @rdf << [vcard_address, RDF.type, RDF::Vocab::VCARD.Address]
          @rdf << [vcard_address, RDF.type, RDF::Vocab::VCARD.Work]
          @rdf << [vcard_address, RDF::RDFS.label, label] if label
          country = office['country'] || 'United States'
          @rdf << [vcard_address, RDF::Vocab::VCARD.send('country-name'), country]
          @rdf << [vcard_address, RDF::Vocab::VCARD.region, office['state']]
          @rdf << [vcard_address, RDF::Vocab::VCARD.locality, office['city']]
          @rdf << [vcard_address, RDF::Vocab::VCARD.send('postal-code'), office['zip']]
          @rdf << [vcard_address, RDF::Vocab::VCARD.send('street-address'), office['address']]
          if office['phoneNumbers']
            phones = office['phoneNumbers'].map {|p| p.gsub(/\W+/,'') }.to_set
            phones.each do |p|
              tel = "tel:#{p}"
              vcard_phone = vcard_address + "/phoneNumber/#{tel}"
              @rdf << [vcard_address, RDF::Vocab::VCARD.hasTelephone, vcard_phone]
              @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Voice]
              @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Work]
              @rdf << [vcard_phone, RDF::Vocab::VCARD.hasValue, tel]
            end
          end
        end
        # Contacts (email and telephone)
        contact_types = ['primaryContact', 'alternateContact']
        contact_types.each do |contact_type|
          contact = profile[contact_type]
          if contact
            contact_uri = vcard + "/#{contact_type}"
            @rdf << [vcard, RDF::Vocab::VCARD.hasRelated, contact_uri]
            @rdf << [contact_uri, RDF::RDFS.label, contact_type]
            @rdf << [contact_uri, RDF.type, RDF::Vocab::VCARD.Contact]
            @rdf << [contact_uri, RDF.type, RDF::Vocab::VCARD.Work]
            profile_contact_email(contact, contact_uri)
            profile_contact_telephone(contact, contact_uri)
          end
        end
        # Web Links
        profiles_url = profile_link('https://cap.stanford.edu/rel/public')
        if profiles_url
          vcard_url = vcard + '/links/public'
          @rdf << [vcard, RDF::Vocab::VCARD.hasURL, vcard_url]
          @rdf << [vcard_url, RDF.type, RDF::Vocab::VCARD.Work]
          @rdf << [vcard_url, RDF::RDFS.label, "CAP public profile"]
          @rdf << [vcard_url, RDF::Vocab::VCARD.hasValue, profiles_url]
        end
      end

      # Does this profile have a 'physician' affiliation?
      def physician?
        profile['affiliations']['physician']
      end

      # Extract and add physician data to the VIVO RDF
      def vcard_physician(vcard)
        if physician?
          # Create Vcard data for physician data, e.g.


          # "californiaPhysicianLicense"=>"G17XXX",
          # "clinicalContacts"=>
          #  [{"address"=>"99999 Watson Ct",
          #    "address2"=>"MC 9999",
          #    "city"=>"Palo Alto",
          #    "fax"=>"(650) 999-9999",
          #    "name"=>"Jack Rabbit, MD",
          #    "officeName"=>"Stanford Eyes",
          #    "phoneNumbers"=>["(650) 999-9999"],
          #    "state"=>"CA",
          #    "title"=>"Clinical Associate Professor",
          #    "zip"=>"94303"}],
          # "clinicalFocus"=>["Ophthalmology"],
          # "clinicalPractices"=>
          #  [{"id"=>"shc",
          #    "label"=>
          #     { "text"=>"Stanford Hospital and Clinics"},
          #    "name"=>"Stanford Hospital and Clinics",
          #    "url"=>"http://www.stanfordhospital.org"}],
          # "department"=>"Ophthalmology",

        end
      end



      # Extract and add contact email data to the VIVO RDF
      # @param contact [Hash] profile contact data
      # @param contact_uri [RDF::URI] profile contact URI
      def profile_contact_email(contact, contact_uri)
        if contact['email']
          vcard_email = contact_uri + '/email'
          @rdf << [contact_uri, RDF::Vocab::VCARD.hasEmail, vcard_email]
          @rdf << [vcard_email, RDF.type, RDF::Vocab::VCARD.Work]
          label = contact['type'] || contact['label'] || ''
          unless label.empty?
            @rdf << [vcard_email, RDF::RDFS.label, RDF::Literal.new(label)]
          end
          # The 'email' field might contain multiple entries, separated by
          # various kinds of delimiter and each item is not necessarily
          # validated, so this is an attempt to clean up some things, but
          # it's not fool proof.  For more on this topic, see
          # http://davidcel.is/posts/stop-validating-email-addresses-with-regex/
          emails = contact['email'].split
          emails.each do |email|
            email = email.gsub(/,\z/,'').gsub(/>.*/,'').gsub(/\A</,'')
            email = RDF::URI.parse("mailto:#{email}")
            @rdf << [vcard_email, RDF::Vocab::VCARD.hasValue, email]
          end
        end
      end

      # Extract and add contact telephone data to the VIVO RDF
      # @param contact [Hash] profile contact data
      # @param contact_uri [RDF::URI] profile contact URI
      def profile_contact_telephone(contact, contact_uri)
        if contact['phoneNumbers']
          phones = contact['phoneNumbers'].map {|p| p.gsub(/\W+/,'') }.to_set
          phones.each do |p|
            vcard_phone = contact_uri + "/phone/#{p}"
            @rdf << [contact_uri, RDF::Vocab::VCARD.hasTelephone, vcard_phone]
            @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Voice]
            @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Work]
            @rdf << [vcard_phone, RDF::Vocab::VCARD.hasValue, p]
          end
        end
      end


      # Retrieve profile link URLs, using the link relation, such as:
      # Profiles - 'https://cap.stanford.edu/rel/public'
      # CAP API  - 'https://cap.stanford.edu/rel/self'
      # @param link_rel [String] the link relation required
      # @return uri [RDF::URI|nil] Stanford Profiles URL
      def profile_link(link_rel)
        uri = nil
        profile['meta']['links'].each do |link|
          if link['rel'] == link_rel
            uri = RDF::URI.parse link['href']
          end
        end
        uri
      end

      def prov
        prov_mapping  # create most of the PROV once
        vivo_modified = RDF::Literal.new(Time.now.utc, :datatype => RDF::XSD.dateTime)
        t = Time.parse(profile['lastModified']).utc
        cap_modified = RDF::Literal.new(t, :datatype => RDF::XSD.dateTime)
        @vivo_uri ||= @uri
        @cap_uri  ||= profile_link('https://cap.stanford.edu/rel/self')
        @rdf << [@vivo_uri, RDF.type, RDF::PROV.Entity]
        @rdf << [@cap_uri,  RDF.type, RDF::PROV.Entity]
        @rdf << [@cap_uri,  RDF::PROV.generatedAtTime, cap_modified]
        @rdf << [@vivo_uri, RDF::PROV.wasDerivedFrom, @cap_uri]
        @rdf << [@vivo_uri, RDF::PROV.wasGeneratedBy, MAPPING_ACTIVITY]
        @rdf << [@vivo_uri,  RDF::PROV.generatedAtTime, vivo_modified]
        @rdf << [MAPPING_ACTIVITY, RDF::PROV.used, @cap_uri]
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
          g.each_statement {|s| @config.rdf_repo.insert_statement s}
          true
        rescue => e
          @config.logger.error e.message
          false
        end
      end

      def save
        @rdf.each_statement {|s| @config.rdf_repo.insert_statement s};
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
