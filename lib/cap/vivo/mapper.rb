require_relative 'orgs'
require_relative 'prov'
require_relative 'vivo_terms'

module Cap
  module Vivo

    class Mapper

      include Cap::Vivo::Orgs
      include Cap::Vivo::Prov
      include Cap::Vivo::VivoTerms

      PROFILE_URI_PREFIX = RDF::URI.parse 'https://profiles.stanford.edu/vivo'

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
        vivo_position
        vivo_vcard
        prov
      end

      def vivo_position
        if faculty?
          @rdf << [@uri, RDF.type, RDF::VIVO.FacultyMember]
        end
        # RDF::VIVO.Student in CAP?
        if md_student? || ms_student? || phd_student?
          @rdf << [@uri, RDF.type, RDF::VIVO.Student]
          @rdf << [@uri, RDF.type, RDF::VIVO.GraduateStudent]
        end
        if postdoc?
          @rdf << [@uri, RDF.type, RDF::VIVO.Postdoc]
        end
        if staff?
          @rdf << [@uri, RDF.type, RDF::VIVO.NonAcademic]
          # OR RDF::VIVO.NonFacultyAcademic for research staff?
        end
        # RDF::VIVO.MedicalResidency in CAP?
        # if physician?  # VIVO equivalent?
      end

      # Map names, addresses, contacts and web links to vcard data.
      def vivo_vcard
        vcard = @uri + '/vcard'
        @rdf << [@uri, HAS_CONTACT_INFO, vcard]
        @rdf << [vcard, RDF.type, RDF::VIVO_VCARD.Individual]
        # Names
        profile['names'].each_pair do |type, name|
          fn = name['firstName'] || ''
          mn = name['middleName'] || ''
          ln = name['lastName'] || ''
          # Add name label to @uri
          @rdf << [@uri, RDF::RDFS.label, "#{ln}, #{fn}"]
          # Add name to vcard
          vcard_name = vcard + "/names/#{type}"
          @rdf << [vcard, RDF::VIVO_VCARD.hasName, vcard_name]
          @rdf << [vcard_name, RDF.type, RDF::VIVO_VCARD.Name]
          @rdf << [vcard_name, RDF::RDFS.label, type]
          # The VIVO-ISF v1.6 uses an older version of VCARD than the
          # version currently in RDF::Vocab::VCARD.
          @rdf << [vcard_name, RDF::VIVO_VCARD.givenName, fn]
          @rdf << [vcard_name, RDF::VIVO_VCARD.familyName, ln]
          unless mn.empty?
            @rdf << [vcard_name, RDF::VIVO.middleName, mn]
          end
        end

        # TODO:  Title
        # <http://vivo.school.edu/individual/fac1307-vcard-title> a vcard:Title ;
        # vcard:title "Professor" .

        # Addresses
        offices = profile['academicOffices'] || []
        offices.each do |office|
          id = offices.length > 1 ? SecureRandom.hex(5) : office['type']
          label = office['label'] || office['officeName']
          vcard_address = vcard + "/academicOffices/#{id}"
          @rdf << [vcard, RDF::VIVO_VCARD.hasAddress, vcard_address]
          @rdf << [vcard_address, RDF.type, RDF::VIVO_VCARD.Address]
          @rdf << [vcard_address, RDF.type, RDF::VIVO_VCARD.Work]
          @rdf << [vcard_address, RDF::RDFS.label, label] if label
          profile_address(office, vcard_address)
          profile_telephone(office, vcard_address)
        end
        # Contacts (email and telephone)
        contact_types = ['primaryContact', 'alternateContact']
        contact_types.each do |contact_type|
          contact = profile[contact_type]
          if contact
            contact_uri = vcard + "/#{contact_type}"
            @rdf << [vcard, RDF::VIVO_VCARD.hasRelated, contact_uri]
            @rdf << [contact_uri, RDF.type, RDF::VIVO_VCARD.Contact]
            @rdf << [contact_uri, RDF.type, RDF::VIVO_VCARD.Work]
            @rdf << [contact_uri, RDF::RDFS.label, contact_type]
            profile_email(contact, contact_uri)
            profile_telephone(contact, contact_uri)
          end
        end
        # Web Links
        profiles_url = profile_link('https://cap.stanford.edu/rel/public')
        if profiles_url
          vcard_url = vcard + '/links/public'
          @rdf << [vcard, RDF::VIVO_VCARD.hasURL, vcard_url]
          @rdf << [vcard_url, RDF.type, RDF::VIVO_VCARD.Work]
          @rdf << [vcard_url, RDF::RDFS.label, "CAP public profile"]
          @rdf << [vcard_url, RDF::VIVO_VCARD.url, profiles_url]
        end
      end

      # Inspect the affiliations for this profile
      # @param kind [String] kind of affiliation
      # @return bool [Boolean]
      def affiliations(kind)
        profile['affiliations'][kind] || false
      end
      # Does this profile have a faculty affiliation?
      def faculty?
        affiliations 'capFaculty'
      end
      # Does this profile have a physician affiliation?
      def physician?
        affiliations 'physician'
      end
      # Does this profile have a staff affiliation?
      def staff?
        affiliations 'capStaff'
      end
      # Does this profile have a MD student affiliation?
      def md_student?
        affiliations 'capMdStudent'
      end
      # Does this profile have a MS student affiliation?
      def ms_student?
        affiliations 'capMsStudent'
      end
      # Does this profile have a PhD student affiliation?
      def phd_student?
        affiliations 'capPhdStudent'
      end
      # Does this profile have a post-doc affiliation?
      def postdoc?
        affiliations 'capPostdoc'
      end


      # Extract and add physician VCard data to the VIVO RDF
      def vcard_physician(vcard)
        if physician?
          # The 'clinicalContacts' field contains clinical office address
          # and contact details
          contacts = profile['clinicalContacts'] || []
          contacts.each do |contact|
            if contact['officeName']
              id = URI.escape contact['officeName'].gsub(/\W+/,'')
              label = contact['officeName']
            else
              id = SecureRandom.hex(5)
              label = nil
            end
            contact_uri = vcard + "/clinicalContact/#{id}"
            @rdf << [vcard, RDF::VIVO_VCARD.hasRelated, contact_uri]
            @rdf << [contact_uri, RDF.type, RDF::VIVO_VCARD.Contact]
            @rdf << [contact_uri, RDF.type, RDF::VIVO_VCARD.Work]
            @rdf << [contact_uri, RDF::RDFS.label, label] if label
            contact_address = contact_uri + "/address"
            @rdf << [contact_uri, RDF::VIVO_VCARD.hasAddress, contact_address]
            @rdf << [contact_address, RDF.type, RDF::VIVO_VCARD.Address]
            @rdf << [contact_address, RDF.type, RDF::VIVO_VCARD.Work]
            @rdf << [contact_address, RDF::RDFS.label, label] if label
            profile_address(office, contact_address)
            profile_email(contact, contact_uri)
            profile_telephone(contact, contact_uri)
          end

          # "californiaPhysicianLicense"=>"G17XXX",
          # "clinicalContacts"=>
          #  [{
          #
          #
          #
          #    "name"=>"Jack Rabbit, MD",
          #    "officeName"=>"Stanford Eyes",
          #
          #
          #    "title"=>"Clinical Associate Professor",
          #   }],
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


      # Extract and add address data to the parent entity
      # @param parent [Hash] profile data containing address data
      # @param parent_uri [RDF::URI] profile entity containing address
      def profile_address(parent, parent_uri)
        country = parent['country'] || 'United States'
        @rdf << [parent_uri, RDF::VIVO_VCARD.country, country]
        @rdf << [parent_uri, RDF::VIVO_VCARD.region, parent['state']]
        @rdf << [parent_uri, RDF::VIVO_VCARD.locality, parent['city']]
        @rdf << [parent_uri, RDF::VIVO_VCARD.postalCode, parent['zip']]
        address = parent['address']
        address += ", #{parent['address2']}" if parent['address2']
        @rdf << [parent_uri, RDF::VIVO_VCARD.streetAddress, address]
      end

      # Extract and add email data to the parent entity
      # @param parent [Hash] profile data containing 'email' field
      # @param parent_uri [RDF::URI] profile entity containing email
      def profile_email(parent, parent_uri, pref=false)
        if parent['email']
          vcard_email = parent_uri + '/email'
          @rdf << [parent_uri, RDF::VIVO_VCARD.hasEmail, vcard_email]
          @rdf << [vcard_email, RDF.type, RDF::VIVO_VCARD.Work]
          # @rdf << [vcard_email, RDF.type, RDF::Vocab::VCARD.Pref] if pref
          label = parent['type'] || parent['label'] || ''
          @rdf << [vcard_email, RDF::RDFS.label, label] unless label.empty?
          # The 'email' field might contain multiple entries, separated by
          # various kinds of delimiter and each item is not necessarily
          # validated, so this is an attempt to clean up some things, but
          # it's not fool proof.  For more on this topic, see
          # http://davidcel.is/posts/stop-validating-email-addresses-with-regex/
          #
          # TODO: consider using regex:  /.+@.+\..+/i
          #

          # temporarily disable parsing email to log errors.
          email = RDF::URI.parse("mailto:#{parent['email']}")
          @rdf << [vcard_email, RDF::VIVO_VCARD.email, email]

          # emails = parent['email'].split
          # emails.each do |email|
          #   email = email.gsub(/,\z/,'').gsub(/>.*/,'').gsub(/\A</,'')
          #   email = RDF::URI.parse("mailto:#{email}")
          #   @rdf << [vcard_email, RDF::VIVO_VCARD.email, email]
          # end
        end
      end

      # Extract and add telephone data to the parent entity
      # @param parent [Hash] profile data containing 'phoneNumbers' field
      # @param parent_uri [RDF::URI] profile entity containing phone numbers
      def profile_telephone(parent, parent_uri, pref=false)
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
        phones = [parent['phoneNumbers']].flatten.compact
        unless phones.empty?
          phones = phones.map {|p| p.gsub(/\W+/,'') }.to_set
          phones.each do |p|
            vcard_phone = parent_uri + "/phone/#{p}"
            @rdf << [parent_uri, RDF::VIVO_VCARD.hasTelephone, vcard_phone]
            @rdf << [vcard_phone, RDF.type, RDF::VIVO_VCARD.Work]
            @rdf << [vcard_phone, RDF.type, RDF::VIVO_VCARD.Voice]
            @rdf << [vcard_phone, RDF::VIVO_VCARD.telephone, p]
            # @rdf << [vcard_phone, RDF.type, RDF::Vocab::VCARD.Pref] if pref
          end
        end
        faxes = [parent['fax']].flatten.compact
        unless faxes.empty?
          faxes = faxes.map {|fax| fax.gsub(/\W+/,'') }.to_set
          faxes.each do |fax|
            vcard_fax = parent_uri + "/fax/#{fax}"
            @rdf << [parent_uri, RDF::VIVO_VCARD.hasTelephone, vcard_fax]
            @rdf << [vcard_fax, RDF.type, RDF::VIVO_VCARD.Work]
            @rdf << [vcard_fax, RDF.type, RDF::VIVO_VCARD.Fax]
            @rdf << [vcard_fax, RDF::VIVO_VCARD.telephone, fax]
            # @rdf << [vcard_fax, RDF.type, RDF::Vocab::VCARD.Pref] if pref
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
        @vivo_uri ||= @uri
        @cap_uri  ||= profile_link('https://cap.stanford.edu/rel/self')
        cap_modified = profile['lastModified']
        @rdf << prov_profile(@rdf, @vivo_uri, @cap_uri, cap_modified)
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
