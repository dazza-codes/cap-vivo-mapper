module Cap
  module Vivo
    module VivoTerms

      # The VIVO-ISF v1.6 uses an older version of VCARD than the
      # version currently in the RDF::Vocab library.  Define a few
      # custom URIs here for the older VCARD vocabulary.
      VCARD_PREFIX = RDF::URI.parse 'http://www.w3.org/2006/vcard/ns#'
      VCARD_givenName  = VCARD_PREFIX + 'givenName'
      VCARD_familyName = VCARD_PREFIX + 'familyName'

      HAS_CONTACT_INFO = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000028'
      CONTACT_INFO_FOR = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000029'

      DATA_NAMESPACE = ENV['DATA_NAMESPACE'] || 'https://vivo.stanford.edu'

      VIVO_CONTEXT = {
        '@context' => {
          '@base' => DATA_NAMESPACE,
          'a' => '@type',
          'uri' => '@id',
          'foaf' => RDF::FOAF.to_s,
          'obo' => 'http://purl.obolibrary.org/obo/',
          'rdfs' => RDF::RDFS.to_s,
          'vcard' => RDF::VIVO_VCARD.to_s,
          'vivo' => RDF::VIVO.to_s,
          'FacultyMember' => 'vivo:FacultyMember',
          'label' => 'rdfs:label',
          'firstName'  => 'vcard:givenName',
          'lastName'   => 'vcard:familyName',
          'middleName' => 'vivo:middleName',
          'vivo:relates' => {
              '@type' => '@id',
          },
          'contact' => {
              '@id' => 'obo:ARG_2000028',
              '@type' => '@id',
              'label' => 'has contact info'
          },
          'contactFor' => {
              '@id' => 'obo:ARG_2000029',
              '@type' => '@id',
              'label' => 'contact info for'
          },
          # Connecting a person to a role
          'bearerOf' => {
              '@id' => 'obo:RO_0000053',
              '@type' => '@id',
              'label' => 'bearer of'
          },
          # Connecting a role to a person
          'inheresIn' => {
              '@id' => 'obo:RO_0000052',
              '@type' => '@id',
              'label' => 'inheres in'
          },
          # 'vcard:hasName' => {
          #     '@id' => 'vcard:hasName',
          #     '@type' => '@id'
          # },
          # 'vcard:hasTitle' => {
          #     '@id' => 'vcard:hasTitle',
          #     '@type' => '@id'
          # },
          # 'vcard:hasAddress' => {
          #     '@id' => 'vcard:hasAddress',
          #     '@type' => '@id'
          # },
          # 'vcard:hasEmail' => {
          #     '@id' => 'vcard:hasEmail',
          #     '@type' => '@id'
          # },
          # 'vcard:hasPhone' => {
          #     '@id' => 'vcard:hasTelephone',
          #     '@type' => '@id'
          # },
          # 'vcard:hasFax' => {
          #     '@id' => 'vcard:hasTelephone',
          #     '@type' => '@id'
          # },
          # 'vcard:hasURL' => {
          #     '@id' => 'vcard:hasURL',
          #     '@type' => '@id'
          # },
        }
      }

      # Create a person URI
      # @param id [Fixnum] a CAP profile ID number
      # @return uri [String]
      def vivo_person_uri(id)
        DATA_NAMESPACE + "/person/#{id}"
      end

      # Extract vcard address from data
      # @param data [Hash] data containing address fields
      # @return address [Hash] vard address data
      def vcard_address(data)
        address = data['address']
        address += ", #{data['address2']}" if data['address2']
        {
          'a' => 'vcard:Address',
          'vcard:country' => data['country'] || 'United States',
          'vcard:region' => data['state'],
          'vcard:locality' => data['city'],
          'vcard:postalCode' => data['zip'],
          'vcard:streetAddress' => address
        }
      end

      # Extract email from data
      # @param data [Hash] data containing 'email' field
      # @param uri [RDF::URI] the URI prefix for the email uri
      # @return email [Hash] vcard email data
      def vcard_emails(data, uri)
        # TODO: consider using regex:  /.+@.+\..+/i
        # The 'email' field might contain multiple entries, separated by
        # various kinds of delimiter and each item is not necessarily
        # validated, so this is an attempt to clean up some things, but
        # it's not fool proof.  For more on this topic, see
        # http://davidcel.is/posts/stop-validating-email-addresses-with-regex/
        emails = []
        collect = data['email'].split rescue []
        collect.each_with_index do |email, i|
          email = email.gsub(/,\z/,'').gsub(/>.*/,'').gsub(/\A</,'')
          emails << {
            '@id' => uri + "/email/#{i}",
            'a' => 'vcard:Email',
            'vcard:email' => email
          }
        end
        emails
      end

      # Extract telephone data
      # @param data [Hash] data containing 'phoneNumbers' field
      # @param uri [RDF::URI] the URI prefix for the telephone uri
      # @return telephones [Array<Hash>] telephone data
      def vcard_telephones(data, uri)
        #
        # TODO: differentiate between phone types, e.g.
        #       http://www.w3.org/TR/vcard-rdf/#Code_Sets for Telephone Type
        #
        #       VCARD.Cell  - mobile phones
        #       VCARD.Car   - car phones
        #       VCARD.Msg   - voice message service
        #       VCARD.Pager - paging service
        #       VCARD.Pref  - preferred {address, email, phone}
        #       VCARD.Text  - simple message service (SMS)
        #       VCARD.Video - video message service
        #
        phones = [data['phoneNumbers']].flatten.compact
        phones = phones.map {|p| p.gsub(/\W+/,'') }.to_set
        phones.map do |p|
          {
            '@id' => uri + "/phone/#{p}",
            'a' => ['vcard:Telephone','vcard:Voice'],
            'vcard:telephone' => p
          }
        end
      end

      # Extract fax data
      # @param data [Hash] data containing 'fax' field
      # @param uri [RDF::URI] the URI prefix for the fax uri
      # @return faxes [Array<Hash>] fax data
      def vcard_faxes(data, uri)
        faxes = [data['fax']].flatten.compact
        faxes = faxes.map {|fax| fax.gsub(/\W+/,'') }.to_set
        faxes.map do |fax|
          {
            '@id' => uri + "/fax/#{fax}",
            'a' => ['vcard:Telephone','vcard:Fax'],
            'vcard:telephone' => fax
          }
        end
      end

      # Create vivo:AdvisorRole
      # The URI appends '/advisor' to the person_uri
      # @param person_uri [String] from vivo_person_uri
      # @return advisor_role [Hash]
      def vivo_advisor_role(person_uri)
        {
          '@id' => person_uri + '/advisor',
          'a' => 'vivo:AdvisorRole',
          'vivo:relatedBy' => []
        }
      end

      # Create vivo:AdviseeRole
      # @param person_uri [String] from vivo_person_uri
      # @return advisee_role [Hash]
      def vivo_advisee_role(person_uri)
        {
          '@id' => person_uri + '/advisee',
          'a' => 'vivo:AdviseeRole',
          'vivo:relatedBy' => []
        }
      end

      # Create a vivo:AdvisingRelationship
      # The relationship URI appends '/advising/{advisee_id}' to the advisor URI.
      # The target of the relationship is the advisee URI.
      # @param advisor_id [Fixnum] a CAP profile ID number
      # @param advisee_id [Fixnum] a CAP profile ID number
      # @return advising_relationship [Hash]
      def vivo_advising_relationship(advisor_id, advisee_id)
        advisor_uri = vivo_person_uri(advisor_id)
        advisee_uri = vivo_person_uri(advisee_id)
        {
          '@id' => advisor_uri + "/advising/#{advisee_id}",
          'a' => ['vivo:AdvisingRelationship'],
          'vivo:relates' => [advisor_uri, advisee_uri]
        }
      end

    end
  end
end
