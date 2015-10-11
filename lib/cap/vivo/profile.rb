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
        vivo_processing
      end

      # @return legal_name [Hash]
      def legal_name
        profile['names']['legal']
      end
      # @return legal_name [String]
      def full_name
        @full_name   ||= begin
          names = [first_name, middle_name, last_name].compact
          names.join(' ')
        end
      end
      # @return legal_first_name [String|nil]
      def first_name
        legal_name['firstName']
      end
      # @return legal_middle_name [String|nil]
      def middle_name
        legal_name['middleName']
      end
      # @return legal_last_name [String|nil]
      def last_name
        legal_name['lastName']
      end

      # @return preferred_name [Hash]
      def pref_name
        profile['names']['preferred']
      end
      # @return pref_first_name [String|nil]
      def pref_first_name
        pref_name['firstName']
      end
      # @return pref_middle_name [String|nil]
      def pref_middle_name
        pref_name['middleName']
      end
      # @return pref_last_name [String|nil]
      def pref_last_name
        pref_name['lastName']
      end

      # @return bio [String] biographical description
      def bio
        profile['bio']['text'] rescue nil
      end

      # URL for NIH Biosketch PDF
      # @return uri [String|nil] a link to an NIH Biosketch PDF
      def nih_biosketch
        profile['documents']['nihBiosketch']['url'] rescue nil
      end

      # @return research_interests [String|nil] research description
      def research_interests
        profile['currentResearchInterests']['fullText']['html'] rescue nil
      end

      # Position title
      # profile['shortTitle']['title']
      def profile_title
        @profile_title ||= profile['shortTitle']['title'].gsub(/["'\n]/,'')
      end

      # @return primary_contact [Hash|nil]
      def primary_contact
        profile['primaryContact']
      end

      # @return alternate_contact [Hash|nil]
      def alternate_contact
        profile['alternateContact']
      end

      # # Profile contact
      # # primary or alternate contact
      # def profile_contact
      #   @profile_contact ||= begin
      #     profile['primaryContact'] || profile['alternateContact'] || {}
      #   end
      # end

      # Creates a VIVO profile (in jsonld)
      # @return vivo [Hash] a VIVO jsonld hash
      def vivo
        @vivo ||= vivo_init
      end

      # Initialize the VIVO data with:
      # @return vivo [Hash]
      def vivo_init
        {
          '@id' => @uri,
          'a' => ['foaf:Person'],
          'label' => "#{last_name}, #{first_name}",
        }
      end

      # TODO: Extract identification data compatible with VIVO, including:
      # ORCID, eRA Commons, ISI Researcher, Scopus, health care provider
      # TODO: try to find an ORCID
      # Use a publication DOI to identify an author's ORCID
      # http://members.orcid.org/api/tutorial-retrieve-data-public-api-curl-12-and-earlier
      # http://members.orcid.org/api/code-examples
      # http://members.orcid.org/finding-orcid-record-holders-your-institution
      # http://members.orcid.org/api/tutorial-searching-api-12-and-earlier
      #
      # For physicians:
      # californiaPhysicianLicense
      # npi - https://en.wikipedia.org/wiki/National_Provider_Identifier
      def vivo_identity
      end

      # Enhance the VIVO data with:
      # - contacts
      # - biographical overview
      # - positions
      # - advising relationships
      def vivo_processing
        begin
          vivo['contact'] = vcards
          vivo_affiliations
          vivo_advising  # process advisor/advisee relationships
          vivo['vivo:relatedBy'] = vivo_positions  # array of positions
          vivo['vivo:overview'] = bio if bio
          vivo['vivo:researchOverview'] = research_interests if research_interests
          # TODO: process clinical trials data
          #clinical_trials
        rescue => e
          msg = sprintf "FAILED VIVO processing for profileId %d\n", @id
          msg += e.message
          msg += e.backtrace.join("\n")
          puts msg
          @config.logger.error(msg)
        end
      end

      # Convert @vivo jsonld hash into an RDF::Graph
      # @return vivo_graph [RDF::Graph]
      def vivo_graph
        @vivo_graph ||= from_jsonld(vivo, VIVO_CONTEXT)
      end

      # Create an RDF::Graph for any data that belongs outside the
      # triples for this profile, such as student advisors or the
      # students avised by a professor.
      # @return vivo_outside_graph [RDF::Graph]
      def vivo_outside_graph
        @vivo_outside_graph ||= begin
          g = RDF::Graph.new
          @vivo_outside_advisees.each do |advisee|
            g << from_jsonld(advisee, VIVO_CONTEXT)
          end
          @vivo_outside_advisors.each do |advisor|
            g << from_jsonld(advisor, VIVO_CONTEXT)
          end
          g
        end
      end

      # Map names, addresses, contacts and web links to vcard data.
      # @return vcards [Array<Hash>] an array of vcards
      def vcards
        @vcards ||= begin
          vcards = []
          vcards.push primary_vcard if primary_contact
          vcards.push alternate_vcard if alternate_contact
          # TODO: clinical contacts
          # vcards.push clinical_vcard if clinical_contact
          vcards
        end
      end

      # Map names, addresses, contacts and web links to vcard data.
      # @return vcard [Hash] a vcard
      def primary_vcard
        vcard_uri = @uri + '/vcard/primary'
        vcard = {
          '@id' => vcard_uri,
          'a' => ['vcard:Individual','vcard:Work'],
          'label' => "Primary contact for #{full_name}",
          'contactFor' => @uri,
        }
        vcard['vcard:hasName'] = {
          '@id' => vcard_uri + '/name',
          'a' => ['vcard:Name','vcard:Work'],
          'firstName' => first_name,
          'middleName' => middle_name,
          'lastName' => last_name
        }
        title = primary_contact['title']
        if title
          vcard['vcard:hasTitle'] = {
            '@id' => vcard_uri + '/title',
            'a' => ['vcard:Title','vcard:Work'],
            'vcard:title' => title
          }
        end
        email = vcard_emails(primary_contact, vcard_uri).first
        if email
          email['a'].push 'vcard:Work'
          vcard['vcard:hasEmail'] = email
        end
        tel = vcard_telephones(primary_contact, vcard_uri).first
        if tel
          tel['a'].push 'vcard:Work'
          vcard['vcard:hasTelephone'] = tel
        end
        fax = vcard_faxes(primary_contact, vcard_uri).first
        if fax
          fax['a'].push 'vcard:Work'
          vcard['vcard:hasFax'] = fax
        end
        vcard['vcard:hasURL'] = []
        url = profile_link('https://cap.stanford.edu/rel/public')
        if url
          vcard_url = {
            '@id' => vcard_uri + '/cap_profile',
            'a' => ['vcard:URL', 'vcard:Work'],
            'label' => 'CAP public profile',
            'vcard:url' => url
          }
          vcard['vcard:hasURL'].push vcard_url
        end
        url = nih_biosketch
        if url
          vcard_url = {
            '@id' => vcard_uri + '/nih_biosketch',
            'a' => ['vcard:URL', 'vcard:Work'],
            'label' => 'NIH Biosketch (PDF)',
            'vcard:url' => url
          }
          vcard['vcard:hasURL'].push vcard_url
        end
        links = profile['internetLinks']
        if links
          links.each_with_index do |link,i|
            vcard_url = {
              '@id' => vcard_uri + "/link#{i}",
              'a' => ['vcard:URL', 'vcard:Work'],
              'label' => link['label']['text'],
              'vcard:url' => link['url']
            }
            vcard['vcard:hasURL'].push vcard_url
          end
        end
        offices = profile['academicOffices']
        if offices
          vcard['vcard:hasAddress'] = offices.collect do |office|
            address = vcard_address(office) rescue {}
            unless address.empty?
              office_name = office['officeName'].gsub(/\W+/,'')
              address['@id'] = vcard_uri + "/#{office_name}"
            end
            address
          end
        end
        vcard
      end

      # The alternate contact is an ambiguous dataset in CAP.  Most often, it is
      # an admin assistant, but not always.  Sometimes it is a secondary contact
      # email or phone number for this profile.  There is inconsistent use of
      # fields in the alt contact, so it's not easy to rely on any field
      # existing or containing useful information for disambiguation.  The
      # approach adopted here is to extract only an email and phone number.
      #
      # Note: alternative contacts are often an admin assistant, who should be
      # an additional person in vivo with contact details attached to that
      # person and a vivo relationship to identify the admin/faculty
      # relationship.
      def alternate_vcard
        if alternate_contact
          label = alternate_contact['title'] || alternate_contact['label']
          label ||= "Alternate contact for #{full_name}"
          vcard_uri = @uri + '/vcard/alternate'
          vcard = {
            '@id' => vcard_uri,
            'a' => ['vcard:Individual'], # 'vcard:Work' only in primary contact
            'label' => label,
            'contactFor' => @uri,
          }
          email = vcard_emails(alternate_contact, vcard_uri).first
          vcard['vcard:hasEmail'] = email if email
          tel = vcard_telephones(alternate_contact, vcard_uri).first
          vcard['vcard:hasTelephone'] = tel if tel
          vcard
          # Note: don't use the name or title because it can
          #       interfere with the VIVO profile display.
          # name = alternate_contact['name']
          # if name
          #   names = name.split
          #   vcard['vcard:hasName'] = {
          #     '@id' => vcard_uri + '/name',
          #     'a' => ['vcard:Name'],
          #     'firstName' => names.first,
          #     'lastName' => names.last
          #   }
          # end
          # title = alternate_contact['title']
          # if title
          #   vcard['vcard:hasTitle'] = {
          #     '@id' => vcard_uri + '/title',
          #     'a' => ['vcard:Title'],
          #     'vcard:title' => title
          #   }
          # end
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

      def vivo_affiliations
        # RDF::VIVO.Librarian
        # RDF::VIVO.LibrarianPosition
        if faculty?
          # RDF::VIVO.FacultyAdministrativePosition
          vivo['a'].push 'vivo:FacultyMember'
        end
        if postdoc?
          # vivo:Postdoc subClassOf vivo:NonFacultyAcademic
          # vivo:PostdocPosition subClassOf vivo:NonFacultyAcademicPosition
          # vivo:PostdoctoralTraining subClassOf vivo:EducationalProcess
          vivo['a'].push 'vivo:Postdoc' # subClassOf vivo:NonFacultyAcademic
          vivo['participatesIn'] = {
            '@id' => @uri + '/PostdoctoralTraining',
            'a' => ['vivo:PostdoctoralTraining'],
            'hasParticipant' => @uri,
          }
          # position = vivo_position(@uri, 'vivo:PostdocPosition')
          # positions.push position
        end
        if md_student? || ms_student? || phd_student?
          # vivo:GraduateStudent subClassOf vivo:Student
          vivo['a'].push 'vivo:GraduateStudent'
          vivo['participatesIn'] = {
            '@id' => @uri + '/GraduateTraining',
            'a' => ['vivo:EducationalProcess'],
            'hasParticipant' => @uri,
          }
          # position = vivo_position(@uri, 'vivo:NonFacultyAcademicPosition')
          # positions.push position
        end
        if staff?
          vivo['a'].push 'vivo:NonAcademic'
          # position = vivo_position(@uri, 'vivo:NonAcademicPosition')
          # positions.push position
          # RDF::VIVO.NonFacultyAcademic for research staff?
          # RDF::VIVO.NonFacultyAcademicPosition
          # org = RDF::Node.new  # TODO: figure out the real org?
          # profile_position(RDF::VIVO.NonAcademicPosition, org)
        end
        # Any CAP data for vivo:UndergraduateStudent ?
        # Any CAP data for vivo:MedicalResidency or vivo:Internship ?
        if physician?  # VIVO equivalent?
          # profile["clinicalContacts"] # array of contact objects
          # profile["clinicalFocus"] # array of strings
          # profile["clinicalPractices"] # array of objects
          # profile["department"] # e.g. "Medicine"
          # profile["section"] # e.g. "Gen. Medical Disciplines"
        end
        # if faculty? && physician? => determine 'vivo:PrimaryPosition' for org.
      end


      def vivo_positions
        @vivo_positions ||= profile['titles'].map do |title|
          case title['affiliation']
          when 'capFaculty'
            type = 'vivo:FacultyPosition'
          when 'capStaff'
            type = 'vivo:NonAcademicPosition'
          when 'capMdStudent', 'capMsStudent', 'capPhdStudent'
            type = 'vivo:NonFacultyAcademicPosition'
          when 'capPostdoc'
            type = 'vivo:PostdocPosition' # subClassOf vivo:NonFacultyAcademic
          # when 'physician'
          else
            # TODO: detect additional title types
            #       see vivo_affilitations also
            require 'pry'
            binding.pry
          end
          label = title['label']['text']  # or title['label']['html']
          uri_suffix = title['label']['text'].gsub(/\W/,'')
          position = {
            '@id' => @uri + "/position/#{uri_suffix}",
            'a' => [type],
            'label' => label
          }
          # properties to add above:
          # vivo:hrJobTitle
          # vivo:dateTimeInterval
          # obo:RO_0000052 'inheresIn'
          # obo:OBI_0000312 'is specified output of'
          # obo:RO_0002353 'output of'
          # obo:RO_0000056 'participates in'
          # vivo:rank
          #
          #
          # TODO: try to use the org_string2thing here
          # TODO: use title['organization']['orgCode'] to lookup details in the
          #       CAP API (maybe get all that data into mongo?)
          # TODO: try to create or find a vcard for the org, probably should be
          #       done in the org_string2thing etc.
          # A postdoc CAP profile may not have enough information to identify
          # the org hosting the postdoc position (institute, school,
          # department). It may be necessary to have the advisor(s) profileIds
          # and, thereby, identify the org for the advisor who is sponsoring
          # the postdoc.  However, the postdoc CAP profile does not identify
          # the advisor by profileId.
          # org = RDF::Node.new  # TODO: figure out the real org?
          # position['vivo:relates'] = org
          org_code = title['organization']['orgCode']
          org_url = title['organization']['orgUrl']
          org_url ||= "http://vivo.stanford.edu/orgs/#{org_code}"
          org = {
            '@id' => org_url,
            'a' => ['vivo:School'],  # this may not be correct, but guess for now.
            'label' => title['organization']['orgCode']
          }
          position['vivo:relates'] = org
          position
        end
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
          # Note on grammar practices for 'adviser' and 'advisor'
          # http://grammarist.com/spelling/adviser-advisor/
          if faculty?
            #
            # TODO: identify any data for these:
            # vivo:FacultyMentoringRelationship
            # vivo:GraduateAdvisingRelationship
            # vivo:UndergraduateAdvisingRelationship
            #
            advisees = profile['postdoctoralAdvisees'] || []
            if advisees.length > 0
              advisor_name = "#{first_name} #{last_name}"
              advisees.each do |advisee|
                advisee_id = advisee['profileId']
                advisee_uri = vivo_person_uri(advisee_id)
                advisee_name = "#{advisee['firstName']} #{advisee['lastName']}"
                # The student_id and student_uri must be the same patterns used
                # in the initialize method when creating the student profile.
                # The creation of these student ids must not be a complete
                # profile creation, or else it might trigger an inf. loop.
                label = "#{advisor_name} adviser to #{advisee_name}"
                advising_rel = vivo_advising_relationship(@id, advisee_id, label)
                advising_rel['a'].push 'vivo:PostdocOrFellowAdvisingRelationship'
                advisor_role = vivo_advisor_role(@id, advisee_id, advising_rel, label)
                @vivo_advising_roles.push advisor_role
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
                label = "#{advisee_name} advised by #{advisor_name}"
                advisee_role = vivo_advisee_role(@id, advisee_id, advising_rel, label)
                vivo_advisee = {
                  '@id' => advisee_uri,
                  'a' => 'foaf:Person',
                  'label' => "#{advisee['lastName']}, #{advisee['firstName']}",
                  'bearerOf' => [advisee_role],
                }
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
            end
          end
          if postdoc? || phd_student? || md_student? || ms_student?
            advisee_name = "#{first_name} #{last_name}"
            advisors = profile["stanfordAdvisors"] || []
            advisors.each do |advisor|
              # As of Oct, 2015:  A postdoc profile does not identify advisors
              # by profileId, so it is not possible to create the advising
              # relationship without more complex queries on the data to
              # identify the advisor.
              if advisor['profileId']
                advisor_id = advisor['profileId']
                advisor_name = advisor['fullName']
                label = "#{advisee_name} advised by #{advisor_name}"
                advising_rel = vivo_advising_relationship(advisor_id, @id, label)
                if postdoc?
                  advising_rel['a'].push 'vivo:PostdocOrFellowAdvisingRelationship'
                else
                  advising_rel['a'].push 'vivo:GraduateAdvisingRelationship'
                end
                advisee_role = vivo_advisee_role(advisor_id, @id, advising_rel, label)
                advisee_role = vivo_postdoc_advisee(@uri)
                @vivo_advising_roles.push advisee_role
              end
            end
            # Advisor types in CAP data:
            # most postdocs have:
            # profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Faculty Sponsor"
            # 47441/62351/37521/63779/53591/62229/38061 (same advisor), 40494/39312/37987 (different advisors) have both:
            # profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Faculty Sponsor"
            # profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Research Mentor"
            # 21125 only has:
            # profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Research Mentor"
            # 46806/61829/44963/45434/60202 have:
            # profile["stanfordAdvisors"][x]["position"] : "Doctoral (Program)"
            # 40059 has:
            # profile["stanfordAdvisors"][x]["position"] : "Doctoral Dissertation Advisor (AC)"
          end
          # RDF::VIVO.MedicalResidency in CAP?
          if physician?  # VIVO equivalent?
          end
          if staff?
          #   advising['a'].push 'vivo:NonAcademic'
          #   # RDF::VIVO.NonFacultyAcademic for research staff?
          #   # RDF::VIVO.NonFacultyAcademicPosition
          #   # RDF::VIVO.NonAcademicPosition
          #   # org = RDF::Node.new  # TODO: figure out the real org?
          #   # profile_position(RDF::VIVO.NonAcademicPosition, org)
          end
        end
        vivo['bearerOf'] = @vivo_advising_roles unless @vivo_advising_roles.empty?
      end


      # Types of VIVO research activity
      # <option value="http://vivoweb.org/ontology/core#Grant">Grant</option>
      # <option value="http://purl.obolibrary.org/obo/ERO_0000015">Human Study</option>
      # <option value="http://vivoweb.org/ontology/core#Project">Project</option>
      # <option value="http://purl.obolibrary.org/obo/ERO_0000014">Research Project</option>

      def clinical_trials
        @@clinical_trials_search ||= 'http://med.stanford.edu/clinicaltrials/api/v1/trials/search'
        @@clinical_trials_client ||= begin
          require 'faraday'
          client = Faraday.new(url: @@clinical_trials_search) do |f|
            # f.use FaradayMiddleware::FollowRedirects, limit: 3
            # f.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
            # f.request :logger, @config.logger
            f.request :json
            f.response :json, :content_type => 'application/json'
            f.adapter Faraday.default_adapter
          end
          client.options.timeout = 90
          client.options.open_timeout = 10
          client
        end
        clinical_trials_url = profile['clinicalTrialsUrl']
        if clinical_trials_url
          search_params = /.*([?].*)/.match(clinical_trials_url)[1]
          response = @@clinical_trials_client.get search_params
          if response.status == 200
            json = response.body
            if json['count'] > 0
              json['trials'].each do |trial|
                # TODO: model the clinical trial data in VIVO.
                # example:
                #
                # {"id"=>"NCT01314963",
                #     "studyTitle"=>"Efficacy of Gamma Camera Used Intraoperatively for ID of Sentinel Lymph Nodes w/ Lymphoscintigraphy",
                #     "stanfordRecruitingStatus"=>"NOT_RECRUITING",
                #     "leadSponsorIsStanford"=>true,
                #     "contactName"=>"Mike YaO",
                #     "contactPhone"=>"3125435207",
                #     "contactEmail"=>"myao1@stanford.edu",
                #     "briefSummary"=>
                #      "\n      Lymphoscintigraphy is an accepted and commonly performed procedure used for staging of\n      certain cancers, especially melanoma and breast cancer. It involves injecting a small amount\n      of radioactivity under the skin in order to identify lymph nodes which should be biopsied\n      (i.e., the \"sentinel node\") to determine if cancer has spread. Our objective is to evaluate\n      the potential benefit of a new, camera-based technology which allows actual images to be\n      obtained intraoperatively in the identification of sentinel nodes.\n    ",
                #     "investigators"=>
                #      [{"profileId"=>6367, "firstName"=>"Craig", "lastName"=>"Levin", "displayName"=>"Craig Levin", "principalInvestigator"=>true}],
                #     "conditions"=>[{"id"=>26, "description"=>"Multiple Myeloma"}]}
              end
            end
          end
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
          prefix = "#{@id}_" + full_name.gsub(/\W/,'')
          f = File.open(File.join(@config.rdf_path, "#{prefix}.ttl"), 'w')
          f.write vivo_graph.to_ttl
          f.close
          unless vivo_outside_graph.empty?
            f = File.open(File.join(@config.rdf_path, "#{prefix}_extras.ttl"), 'w')
            f.write vivo_outside_graph.to_ttl
            f.close
          end
          if @config.rdf_prov
            f = File.open(File.join(@config.rdf_path, "#{prefix}_prov.ttl"), 'w')
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
