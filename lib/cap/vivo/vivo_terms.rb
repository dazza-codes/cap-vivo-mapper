module Cap
  module Vivo
    module VivoTerms

      # The VIVO-ISF v1.6 uses an older version of VCARD than the
      # version currently in the RDF::Vocab library.  Define a few
      # custom URIs here for the older VCARD vocabulary.
      VCARD_PREFIX = RDF::URI.parse 'http://www.w3.org/2006/vcard/ns#'
      VCARD_givenName  = VCARD_PREFIX + 'givenName'
      VCARD_familyName = VCARD_PREFIX + 'familyName'

      DATA_NAMESPACE = ENV['DATA_NAMESPACE'] || 'https://sul-vivo-dev.stanford.edu'

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
          # Not sure why this 'vivo:relates' is required here
          # but without it the jsonld parser creates strings
          # instead of URIs for the values of 'vivo:relates'.
          'vivo:relates' => {
              '@type' => '@id',
          },
          # Some OBO identifiers that are readable.
          'physicianLicense' => 'obo:ARG_0000197',
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
          # Connecting a role to a process, such as education training
          'realizes' => {
              '@id' => 'obo:BFO_0000055',
              '@type' => '@id',
              'label' => 'realizes'
          },
          # Connecting a process to a role; complement to 'realizes'
          'realizedIn' => {
              '@id' => 'obo:BFO_0000054',
              '@type' => '@id',
              'label' => 'realized in'
          },
          # Connecting a person to a role
          'bearerOf' => {
              '@id' => 'obo:RO_0000053',
              '@type' => '@id',
              'label' => 'bearer of'
          },
          # Connecting a role to a person; complement to 'bearerOf'
          'inheresIn' => {
              '@id' => 'obo:RO_0000052',
              '@type' => '@id',
              'label' => 'inheres in'
          },
          # Connecting a person to a process
          'participatesIn' => {
              '@id' => 'obo:RO_0000056',
              '@type' => '@id',
              'label' => 'participates in'
          },
          # Connecting a process to a person; complement to 'participatesIn'
          'hasParticipant' => {
              '@id' => 'obo:RO_0000057',
              '@type' => '@id',
              'label' => 'has participant'
          },
          # process > outcome
          'hasOutput' => {
              '@id' => 'obo:RO_0002234',
              '@type' => '@id',
              'label' => 'has output'
          },
          # outcome > process
          'outputOf' => {
              '@id' => 'obo:RO_0002353',
              '@type' => '@id',
              'label' => 'output of'
          }
        }
      }

      # Create an organization URI
      # @param id [String] An organization identifier
      # @return uri [String]
      def vivo_org_uri(id)
        uri = DATA_NAMESPACE + "/org/#{id}"
        uri.gsub('//','/')
      end

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
          'a' => ['vcard:Address','vcard:Work'],
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
            'a' => ['vcard:Email'],  # must be array to allow addition of types
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


      # Create any kind of vivo:Position
      # @param person_uri [String] from vivo_person_uri
      # @param kind [String] a 'vivo:{TypeOfPosition}'
      # @return position [Hash]
      def vivo_position(person_uri, kind, label=nil)
        type = kind.sub('vivo:','')
        label = label || type.gsub(/([A-Z])/, ' \1').strip
        {
          '@id' => person_uri + '/' + type,
          'a' => [kind],
          'label' => label
        }
      end

      # # Create vivo:FacultyPosition
      # # The URI appends '/FacultyPosition' to the person_uri
      # # @param person_uri [String] from vivo_person_uri
      # # @return faculty_position [Hash]
      # def vivo_faculty_position(person_uri, label='Faculty Position')
      #   # {
      #   #   '@id' => person_uri + '/FacultyPosition',
      #   #   'a' => ['vivo:FacultyPosition'],
      #   #   'label' => label
      #   # }
      #   vivo_position(person_uri, 'vivo:FacultyPosition')
      # end

      # # Create vivo:NonFacultyAcademicPosition
      # # The URI appends '/NonFacultyAcademicPosition' to the person_uri
      # # @param person_uri [String] from vivo_person_uri
      # # @return faculty_position [Hash]
      # def vivo_nonfacultyacademic_position(person_uri, label='Non-Faculty Academic Position')
      #   {
      #     '@id' => person_uri + '/NonFacultyAcademicPosition',
      #     'a' => ['vivo:NonFacultyAcademicPosition'],
      #     'label' => label
      #   }
      # end

      # Create vivo:AdvisorRole
      # The URI appends '/AdvisorRole/{advisee_id}' to the advisor_uri
      # @param advisor_id [Fixnum] a CAP profile ID number
      # @param advisor_id [Fixnum] a CAP profile ID number
      # @param rel [Hash] a vivo_advising_relationship
      # @param label [String] a label for the relationship
      # @return advisor_role [Hash]
      def vivo_advisor_role(advisor_id, advisee_id, rel, label=nil)
        advisor_uri = vivo_person_uri(advisor_id)
        role = {
          '@id' => advisor_uri + "/AdvisorRole/#{advisee_id}",
          'a' => ['vivo:AdvisorRole'],
          'vivo:relatedBy' => [rel]
        }
        role['label'] = label if label
        role
      end

      # Create vivo:AdviseeRole
      # The URI appends '/AdviseeRole/{advisor_id}' to the advisee_uri
      # @param advisor_id [Fixnum] a CAP profile ID number
      # @param advisee_id [Fixnum] a CAP profile ID number
      # @param rel [Hash] a vivo_advising_relationship
      # @param label [String] a label for the relationship
      # @return advisee_role [Hash]
      def vivo_advisee_role(advisor_id, advisee_id, rel, label=nil)
        advisee_uri = vivo_person_uri(advisee_id)
        role = {
          '@id' => advisee_uri + "/AdviseeRole/#{advisor_id}",
          'a' => ['vivo:AdviseeRole'],
          'vivo:relatedBy' => [rel]
        }
        role['label'] = label if label
        role
      end

      # Create a vivo:AdvisingRelationship
      # The relationship URI appends '/advising/{advisee_id}' to the advisor URI.
      # The target of the relationship is the advisee URI.
      # @param advisor_id [Fixnum] a CAP profile ID number
      # @param advisee_id [Fixnum] a CAP profile ID number
      # @param label [String] a label for the relationship
      # @return advising_relationship [Hash]
      def vivo_advising_relationship(advisor_id, advisee_id, label=nil)
        advisor_uri = vivo_person_uri(advisor_id)
        advisee_uri = vivo_person_uri(advisee_id)
        rel = {
          '@id' => advisor_uri + "/advising/#{advisee_id}",
          'a' => ['vivo:AdvisingRelationship'],
          'vivo:relates' => [advisor_uri, advisee_uri]
        }
        rel['label'] = label if label
        rel
      end

    end
  end
end
