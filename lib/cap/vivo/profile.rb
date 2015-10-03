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
        @uri = vivo_person_uri(@id)
      end

      def bio
        @bio ||= profile['bio']['text'] rescue ''
      end

      # Creates a VIVO profile (in jsonld)
      # @return vivo [Hash] a VIVO jsonld hash
      def vivo
        @vivo ||= begin
          vivo_advising  # process advisor/advisee data
          vivo = {
            '@id' => @uri,
            'a' => 'foaf:Person',
            'label' => "#{last_name}, #{first_name}",
            'vivo:overview' => bio,
            'vivo:relatedBy' => [vivo_positions],
            'bearerOf' => @vivo_advising_roles,
            'contact' => vcard,
          }
          vivo.merge(VIVO_CONTEXT)
        end
      end

      # Convert @vivo jsonld hash into an RDF::Graph
      # @return vivo_graph [RDF::Graph]
      def vivo_graph
        @vivo_graph ||= from_jsonld(vivo)
      end

      # Create an RDF::Graph for any data that belongs outside the
      # triples for this profile, such as student advisors or the
      # students avised by a professor.
      # @return vivo_outside_graph [RDF::Graph]
      def vivo_outside_graph
        @vivo_outside_graph ||= begin
          g = RDF::Graph.new
          unless @vivo_outside_advisees.empty?
            g << from_jsonld(@vivo_outside_advisees)
          end
          unless @vivo_outside_advisors.empty?
            g << from_jsonld(@vivo_outside_advisors)
          end
          g
        end
      end

      # Map names, addresses, contacts and web links to vcard data.
      # @return vcard [Hash] a vcard jsonld hash
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
      def profile_title
        @profile_title ||= profile['shortTitle']['title'].gsub(/["'\n]/,'')
      end

      # VCard position title
      # @return vcard_title [Hash] a vcard:Title in jsonld
      def vcard_title
        @vcard_title ||= begin
          {
            '@id' => vcard_uri + "/title",
            'a' => ['vcard:Title','vcard:Work'],
            'vcard:title' => profile_title
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

      # Create vivo:AdvisorRole
      def vivo_postdoc_advisor(person_uri)
        role = vivo_advisor_role(person_uri)
        role['label'] = 'Postdoctoral Advisor'
        role
      end

      # Create vivo:AdviseeRole
      def vivo_postdoc_advisee(person_uri)
        role = vivo_advisee_role(person_uri)
        role['label'] = 'Postdoctoral Student'
        role
      end

      # Create vivo:AdvisorRole and vivo:AdviseeRole, along with associated
      # vivo:AdvisingRelationship.  The method populates instance variables:
      # @vivo_outside_advisees [Array] # person entities outside this profile
      # @vivo_outside_advisors [Array] # person entities outside this profile
      # @vivo_advising_roles   [Array] # roles for this profile
      def vivo_advising
        @vivo_outside_advisees ||= [] # person entities outside this profile
        @vivo_outside_advisors ||= [] # person entities outside this profile
        @vivo_advising_roles   ||= [] # roles for this profile
        begin
          if faculty?
            advisees = profile['postdoctoralAdvisees'] || []
            students = advisees.map {|s| s['profileId']}
            #
            # TODO: remove this binding if this is not a problem.  For now, it's
            # very important to know whether the CAP API provides any student
            # postdoc advisee data that does not have a profileId.
            # TODO: run a mongo query to evaluate this possibility.
            binding.pry if students.include? nil
            #
            if students.length > 0
              advisor_role = vivo_postdoc_advisor(@uri)
              students.each do |student_id|
                # The student_id and student_uri must be the same patterns used
                # in the initialize method when creating the student profile.
                # The creation of these student ids must not be a complete
                # profile creation, or else it might trigger an inf. loop.
                advising_relationship = vivo_advising_relationship(@id, student_id)
                advising_relationship['a'].push 'vivo:PostdocOrFellowAdvisingRelationship'
                advisor_role['vivo:relatedBy'].push advising_relationship
                # Note, the student is 'bearerOf' a vivo:AdviseeRole, which is
                # also vivo:relatedBy this advising_relationship. This should be
                # adequately defined when the student is processed, if the
                # student has a CAP profile that notes the advisor. However, the
                # postdoc CAP profile does not note the advisor profileId.  So, it
                # is not possible to recreate the advising_relationship while
                # processing the student profile.  Hence, the code below must
                # create a partial VIVO profile for the student, which will be
                # completed when the student profile is processed.  The graph
                # will simply accumulate all the predicate:object data
                # for the student URI.
                advisee_uri = vivo_person_uri(student_id)
                advisee_role = vivo_postdoc_advisee(advisee_uri)
                advisee_role['vivo:relatedBy'].push advising_relationship
                vivo_advisee = {
                  '@id' => vivo_person_uri(student_id),
                  'a' => 'foaf:Person',
                  'bearerOf' => [advisee_role],
                }.merge(VIVO_CONTEXT)
                @vivo_outside_advisees.push vivo_advisee
                #
                # TODO: the student profile may have to be pulled from mongo to
                # get any data available on the student enrollment dates.
                #
                # Note, there is not sufficient data in the CAP API to define the
                #       date range for the advising relationship.
                # vivo:dateTimeInterval [
                #     a vivo:DateTimeInterval;
                #     vivo:start [
                #         a vivo:DateTimeValue;
                #         vivo:dateTimeValue "2009-01-01T00:00:00"^^xsd:dateTime ;
                #         vivo:dateTimePrecision vivo:yearPrecision .
                #     ];
                #     # no end date for 'present' ????
                #     vivo:end [
                #         a vivo:DateTimeValue;
                #         vivo:dateTimeValue "now"; # What is now ????
                #         vivo:dateTimePrecision vivo:yearPrecision .
                #     ].
                # ].
              end
              @vivo_advising_roles.push advisor_role
            end

            # TODO: any graduate students with vivo:GraduateAdvisingRelationship

          end
          if postdoc?
            advisee_role = vivo_postdoc_advisee(@uri)
            # TODO: Add advising relationship? Currently not possible (Oct, 2015).
            # A postdoc profile does not identify advisors by profileId, so it
            # is not possible to create the advising relationship without more
            # complex queries on the data to identify the advisor.
            # advising_relationship = vivo_advising_relationship(advisor_id, @id)
            # advising_relationship['a'].push 'vivo:PostdocOrFellowAdvisingRelationship'
            # advisee_role['vivo:relatedBy'].push advising_relationship
            @vivo_advising_roles.push advisee_role
            #
            # "stanfordAdvisors"=>
            #   [{"fullName"=>"Michel Dumontier",
            #     "label"=>
            #      {"html"=>
            #        "<a href=\"https://profiles.stanford.edu/michel-dumontier\">Michel Dumontier</a>, <span>Postdoctoral Faculty Sponsor</span>",
            #       "text"=>"Michel Dumontier, Postdoctoral Faculty Sponsor"},
            #     "position"=>"Postdoctoral Faculty Sponsor",
            #     "profileUrl"=>"https://profiles.stanford.edu/michel-dumontier"}],
          end
          if md_student? || ms_student? || phd_student?
            # RDF::VIVO.GraduateAdvisingRelationship
            # Note: student profile does not identify their advisors.
            # "titles"=>
            #  [{"academicInstituteDisplay"=>false,
            #    "affiliation"=>"capMdStudent",
            #    "bannerDisplay"=>true,
            #    "label"=>{"html"=>"MD Student, expected graduation Spring 2016", "text"=>"MD Student, expected graduation Spring 2016"},
            #    "organization"=>{"orgCode"=>"VAAA", "orgUrl"=>"http://med.stanford.edu"},
            #    "title"=>"MD Student",
            #    "type"=>"MD"},
            #   {"academicInstituteDisplay"=>false,
            #    "affiliation"=>"capPhdStudent",
            #    "bannerDisplay"=>true,
            #    "label"=>
            #     {"html"=>"Ph.D. Student in Neurosciences, admitted Summer 2009",
            #      "text"=>"Ph.D. Student in Neurosciences, admitted Summer 2009"},
            #    "organization"=>{"orgCode"=>"VLFH", "orgUrl"=>"http://neuroscience.stanford.edu/education/phd_program/"},
            #    "title"=>"Ph.D. Student",
            #    "type"=>"PHD"},
            #   {"academicInstituteDisplay"=>false,
            #    "affiliation"=>"capMdStudent",
            #    "bannerDisplay"=>true,
            #    "label"=>{"html"=>"MSTP Student", "text"=>"MSTP Student"},
            #    "organization"=>{"orgCode"=>"VAAA", "orgUrl"=>"http://med.stanford.edu"},
            #    "title"=>"MSTP Student",
            #    "type"=>"MSTP"}]}
          end
          # if staff?
          #   advising['a'].push 'vivo:NonAcademic'
          #   # RDF::VIVO.NonFacultyAcademic for research staff?
          #   # RDF::VIVO.NonFacultyAcademicPosition
          #   # RDF::VIVO.NonAcademicPosition
          #   # org = RDF::Node.new  # TODO: figure out the real org?
          #   # profile_position(RDF::VIVO.NonAcademicPosition, org)
          # end
          # RDF::VIVO.MedicalResidency in CAP?
          # if physician?  # VIVO equivalent?
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

      def save
        save_triple_store
        save_turtle_files
      end

      def save_triple_store
        begin
          repo = @config.rdf_repo
          vivo_graph.each_statement {|s| repo.insert_statement s }
          vivo_outside_graph.each_statement {|s| repo.insert_statement s }
          if @config.rdf_prov
            prov.each_statement {|s| repo.insert_statement s}
          end
        rescue => e
          @config.logger.error e.message
        end
      end

      def save_turtle_files
        begin
          f = File.open(File.join(@config.rdf_path, "#{@id}.ttl"), 'w')
          f.write vivo_graph.to_ttl
          f.close
          unless vivo_outside_graph.empty?
            f = File.open(File.join(@config.rdf_path, "#{@id}_extras.ttl"), 'w')
            f.write vivo_outside_graph.to_ttl
            f.close
          end
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
