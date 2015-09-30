require_relative 'orgs'
require_relative 'prov'
require_relative 'vivo_terms'
require_relative 'graph_utils'

module Cap
  module Vivo

    # A CAP Profile with method to map data into VIVO-ISF, e.g.
    # cap_profile = client.profile(49224);
    # vivo_profile = Cap::Vivo::Profile.new cap_profile;
    # puts vivo_profile.rdf.to_ttl
    class Profile

      include Cap::Vivo::Orgs
      include Cap::Vivo::Prov
      include Cap::Vivo::VivoTerms
      include Cap::Vivo::GraphUtils

      attr_accessor :config

      # profile
      attr_accessor :profile
      attr_reader :id
      attr_reader :uri

      # @param profile [JSON] CAP API profile - json object
      def initialize(profile)
        @config = Cap::Vivo.configuration
        @profile = profile
        @id = profile['profileId']
        @uri = DATA_NAMESPACE + "/person/#{@id}"
      end

      def bio
        @bio ||= profile['bio']['text'] rescue ''
      end

      # Creates a VIVO profile (in jsonld)
      def vivo
        @vivo ||= begin
          vivo = {
            '@id' => @uri,
            'a' => 'foaf:Person',
            'label' => "#{last_name}, #{first_name}",
            'vivo:overview' => bio,
            'vivo:relatedBy' => vivo_positions,
            'contact' => vcard,
          }
          vivo.merge(VIVO_CONTEXT)
        end
      end

      # Map names, addresses, contacts and web links to vcard data.
      def vcard
        @vcard ||= begin
          vcard = {
            '@id' => vcard_uri,
            'a' => 'vcard:Individual',
            'contactFor' => @uri,
            'vcard:hasName' => vcard_name,
            'vcard:hasTitle' => vcard_title,
          }
          unless vcard_email.empty?
            vcard['vcard:hasEmail'] = vcard_email
          end
          unless vcard_telephone.empty?
            vcard['vcard:hasTelephone'] = vcard_telephone
          end
          unless vcard_fax.empty?
            vcard['vcard:hasFax'] = vcard_fax
          end
          unless vcard_link.empty?
            vcard['vcard:hasURL'] = vcard_link
          end
          unless vcard_addresses.empty?
            vcard['vcard:hasAddress'] = vcard_addresses
          end
          vcard.merge(VIVO_CONTEXT)
        end
      end

      # "#{@uri}/vcard"
      def vcard_uri
        @vcard_uri ||= @uri + '/vcard'
      end

      def legal_name
        @legal_name  ||= profile['names']['legal']
      end
      def first_name
        @first_name  ||= legal_name['firstName'] || ''
      end
      def middle_name
        @middle_name ||= legal_name['middleName'] || ''
      end
      def last_name
        @last_name   ||= legal_name['lastName'] || ''
      end

      def vcard_name
        @vcard_name ||= begin
          {
            '@id' => vcard_uri + "/name",
            'a' => 'vcard:Name',
            'firstName' => first_name,
            'middleName' => middle_name,
            'lastName' => last_name
          }
        end
      end

      # Position title
      # profile['shortTitle']['title']
      def vcard_title
        @vcard_title ||= begin
          title = profile['shortTitle']['title'].gsub(/["'\n]/,'')
          {
            '@id' => vcard_uri + "/title",
            'a' => ['vcard:Title','vcard:Work'],
            'vcard:title' => title
          }
        end
      end

      # Stanford Profile Link
      def vcard_link
        @vcard_link ||= begin
          url = profile_link('https://cap.stanford.edu/rel/public')
          if url
            {
              '@id' => vcard_uri + '/link',
              'a' => ['vcard:URL','vcard:Work'],
              'label' => 'CAP public profile',
              'vcard:url' => url
            }
          else
            {}
          end
        end
      end

      # TODO: try to find an ORCID
      # Use a publication DOI to identify an author's ORCID
      # http://members.orcid.org/api/tutorial-retrieve-data-public-api-curl-12-and-earlier
      # http://members.orcid.org/api/code-examples
      # http://members.orcid.org/finding-orcid-record-holders-your-institution
      # http://members.orcid.org/api/tutorial-searching-api-12-and-earlier


      # Email
      def vcard_email
        @vcard_email ||= begin
          contact = profile['primaryContact'] || profile['alternateContact']
          vcard_emails(contact, vcard_uri).first || {}
        end
      end

      # Telephone
      def vcard_telephone
        @vcard_telephone ||= begin
          contact = profile['primaryContact'] || profile['alternateContact']
          vcard_telephones(contact, vcard_uri).first || {}
        end
      end

      # Fax
      def vcard_fax
        @vcard_fax ||= begin
          contact = profile['primaryContact'] || profile['alternateContact']
          vcard_faxes(contact, vcard_uri).first || {}
        end
      end

      # Address
      def vcard_addresses
        @vcard_addresses ||= begin
          offices = profile['academicOffices'] || []
          offices.collect do |office|
            address = vcard_address(office) rescue {}
            unless address.empty?
              office_name = office['officeName'].gsub(/\W+/,'')
              address['@id'] = vcard_uri + "/#{office_name}"
            end
            address
          end
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

      def vivo_positions
        # TODO: determine positions within orgs
        # TODO: determine teacher/student relationships
        # RDF::VIVO.Librarian
        # RDF::VIVO.LibrarianPosition
        @vivo_positions ||= begin
          positions = {
            '@id' => @uri + '/positions',
            'a' => []
          }
          if faculty?
            # RDF::VIVO.FacultyPosition
            # RDF::VIVO.FacultyAdministrativePosition
            # RDF::VIVO.PostdocOrFellowAdvisingRelationship
            positions['a'].push 'vivo:FacultyMember'
            # org = RDF::Node.new  # TODO: figure out the real org?
            # profile_position(RDF::VIVO.FacultyPosition, org)
          end
          # RDF::VIVO.Student in CAP?
          if md_student? || ms_student? || phd_student?
            # RDF::VIVO.StudentOrganization
            # RDF::VIVO.GraduateAdvisingRelationship
            positions['a'].push 'vivo:GraduateStudent'
          end
          if postdoc?
            positions['a'].push 'vivo:Postdoc'
            # RDF::VIVO.PostdocPosition
            # RDF::VIVO.PostdoctoralTraining
            # org = RDF::Node.new  # TODO: figure out the real org?
            # profile_position(RDF::VIVO.PostdocPosition, org)
          end
          if staff?
            positions['a'].push 'vivo:NonAcademic'
            # RDF::VIVO.NonFacultyAcademic for research staff?
            # RDF::VIVO.NonFacultyAcademicPosition
            # RDF::VIVO.NonAcademicPosition
            # org = RDF::Node.new  # TODO: figure out the real org?
            # profile_position(RDF::VIVO.NonAcademicPosition, org)
          end
          # RDF::VIVO.MedicalResidency in CAP?
          # if physician?  # VIVO equivalent?
          positions
        end
      end


      # # Extract and add physician VCard data to the VIVO RDF
      # def vcard_physician(vcard)
      #   if physician?
      #     # The 'clinicalContacts' field contains clinical office address
      #     # and contact details
      #     contacts = profile['clinicalContacts'] || []
      #     contacts.each do |contact|
      #       if contact['officeName']
      #         id = URI.escape contact['officeName'].gsub(/\W+/,'')
      #         label = contact['officeName']
      #       else
      #         id = SecureRandom.hex(5)
      #         label = nil
      #       end
      #       @rdf << [contact_uri, RDF::RDFS.label, label] if label
      #       @rdf << [contact_address, RDF::RDFS.label, label] if label
      #       extract_address(office, contact_address)
      #       profile_email(contact, contact_uri)
      #       profile_telephone(contact, contact_uri)
      #     end
      #     # vivo:ClinicalRole
      #     # "californiaPhysicianLicense"=>"G17XXX",
      #     # "clinicalContacts"=>
      #     #  [{
      #     #
      #     #
      #     #
      #     #    "name"=>"Jack Rabbit, MD",
      #     #    "officeName"=>"Stanford Eyes",
      #     #
      #     #
      #     #    "title"=>"Clinical Associate Professor",
      #     #   }],
      #     # "clinicalFocus"=>["Ophthalmology"],
      #     # "clinicalPractices"=>
      #     #  [{"id"=>"shc",
      #     #    "label"=>
      #     #     { "text"=>"Stanford Hospital and Clinics"},
      #     #    "name"=>"Stanford Hospital and Clinics",
      #     #    "url"=>"http://www.stanfordhospital.org"}],
      #     # "department"=>"Ophthalmology",
      #   end
      # end




      # Retrieve profile link URLs, using the link relation, such as:
      # Profiles - 'https://cap.stanford.edu/rel/public'
      # CAP API  - 'https://cap.stanford.edu/rel/self'
      # @param link_rel [String] the link relation required
      # @return uri [String|nil] Any of the CAP API meta:links
      def profile_link(link_rel)
        uri = nil
        profile['meta']['links'].each do |link|
          if link['rel'] == link_rel
            uri = link['href']
          end
        end
        uri
      end

      def prov
        @prov ||= begin
          prov = RDF::Graph.new
          cap_rel = 'https://cap.stanford.edu/rel/self'
          cap_uri = RDF::URI.parse profile_link(cap_rel)
          cap_modified = profile['lastModified']
          prov_profile(prov, @uri, cap_uri, cap_modified)
        end
      end

      def rdf
        @rdf ||= from_jsonld(vivo)
      end

      def save
        # save to triple store
        begin
          rdf.each_statement {|s| @config.rdf_repo.insert_statement s}
          if @config.rdf_prov
            prov.each_statement {|s| @config.rdf_repo.insert_statement s}
          end
        rescue => e
          @config.logger.error e.message
        end
        # save to turtle files
        begin
          f = File.open(File.join(@config.rdf_path, "#{@id}.ttl"), 'w')
          f.write rdf.to_ttl
          f.close
          if @config.rdf_prov
            f = File.open(File.join(@config.rdf_path, "#{@id}_prov.ttl"), 'w')
            f.write prov.to_ttl
            f.close
          end
        rescue => e
          @config.logger.error e.message
        end
      end

    end
  end
end
