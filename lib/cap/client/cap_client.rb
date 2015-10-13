module Cap
  module Client

    require 'faraday'
    require 'faraday_middleware'

    # CAP Public Website  https://profiles.stanford.edu
    # Profiles API        https://api.stanford.edu/profiles/v1
    # Orgs API            https://api.stanford.edu/cap/v1/orgs
    # Search API          https://api.stanford.edu/cap/v1/search
    # Developer's API     https://cap.stanford.edu/cap-api/console

    class Client

      JSON_CONTENT = 'application/json'

      attr_reader :config
      attr_reader :cap_api
      attr_reader :orgs
      attr_reader :profiles

      # Initialize a new client
      def initialize
        @config = Cap::Client.configuration
        @orgs = Cap.configuration.cap_repo[:orgs]
        @profiles = Cap.configuration.cap_repo[:profiles]
        @presentations = Cap.configuration.cap_repo[:presentations]
        @publications = Cap.configuration.cap_repo[:publications]
        @processed = Cap.configuration.cap_repo[:processed]
        # CAP API
        @cap_uri = 'https://api.stanford.edu'
        @cap_profiles = '/profiles/v1'
        @cap_orgs     = '/cap/v1/orgs'
        @cap_search   = '/cap/v1/search'
        @cap_api = Faraday.new(url: @cap_uri) do |conn|
          # conn.use FaradayMiddleware::FollowRedirects, limit: 3
          # conn.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
          # conn.request :logger, @config.logger
          conn.request :retry, max: 2, interval: 0.5,
                         interval_randomness: 0.5, backoff_factor: 2
          conn.request :json
          conn.response :json, :content_type => JSON_CONTENT
          conn.adapter :httpclient
        end
        @cap_api.options.timeout = 90
        @cap_api.options.open_timeout = 10
        @cap_api.headers.merge!(json_payloads)
        # Authentication
        auth_uri = 'https://authz.stanford.edu/oauth/token'
        @auth = Faraday.new(url: auth_uri) do |conn|
          conn.request  :url_encoded
          conn.response :json, :content_type => JSON_CONTENT
          conn.adapter :httpclient
        end
        @auth.options.timeout = 30
        @auth.options.open_timeout = 10
        @auth.headers.merge!(json_payloads)
      end

      # Reset authentication
      def authenticate!
        @access_expiry = nil
        authenticate
      end

      def authenticate
        if @access_expiry.to_i < Time.now.to_i
          @access_code = nil
          @auth.headers.delete :Authorization
          @cap_api.headers.delete :Authorization
        end
        @access_code || begin
          return false if @config.token_user.empty? && @config.token_pass.empty?
          client = "#{@config.token_user}:#{@config.token_pass}"
          auth_code = 'Basic ' + Base64.strict_encode64(client)
          @auth.headers.merge!({ Authorization: auth_code })
          response = @auth.get "?grant_type=client_credentials"
          return false unless response.status == 200
          access = response.body
          return false if access['access_token'].nil?
          @access_code = "Bearer #{access['access_token']}"
          @access_expiry = Time.now.to_i + access['expires_in'].to_i
          @cap_api.headers[:Authorization] = @access_code
        end
      end

      # Get profiles from CAP API and store into local repo
      def get_profiles
        begin
          if authenticate
            page = 1
            pages = 0
            total = 0
            begin
              while true
                params = "?p=#{page}&ps=100"
                response = @cap_api.get "#{@cap_profiles}#{params}"
                if response.status == 200
                  data = response.body
                  if data['firstPage']
                    pages = data['totalPages']
                    total = data['totalCount']
                    puts "Retrieved #{page} of #{pages} pages (#{total} profiles)."
                  else
                    puts "Retrieved #{page} of #{pages} pages."
                  end
                  profiles = data['values']
                  profiles.each do |profile|
                    profile_save(profile)
                    orgs_collect(profile)
                  end
                  page += 1
                  break if data['lastPage']
                else
                  msg = "Failed to GET profiles page #{page}: #{response.status}"
                  @config.logger.error msg
                  puts msg
                  break
                end
              end
              orgs_process
            rescue => e
              msg = e.message
              binding.pry if @config.debug
              @config.logger.error msg
            ensure
              repo_commit(total)
            end
          else
            msg = "Failed to authenticate"
            @config.logger.error msg
          end
        rescue => e
          msg = e.message
          binding.pry if @config.debug
          @config.logger.error(msg)
        end
      end

      # TODO: provide a method for retrieving the CAP API data
      #       for profileId and lastModified and determine
      #       whether the local repo data should be updated.
      #
      # api/profiles/v1?ps=1&vw=brief
      #
      # def update_profiles
      #   # profile['profileId']
      #   # => 42005
      #   # [13] pry(main)> profile['profileId'].class
      #   # => Fixnum
      #   # [14] pry(main)> profile['lastModified']
      #   # => "2015-08-17T10:55:46.772-07:00"
      # end

      # @return ids [Array<Integer>] profile ids from local repo
      def profile_ids
        @profiles.find.projection({_id:1}).map {|p| p['_id'] }
      end

      # @return ids [Array<Integer>] a profileId for each faculty
      def faculty_ids
        faculty_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for faculty
      def faculty_profiles
        affiliation_profiles('capFaculty')
      end

      # @return ids [Array<Integer>] a profileId for each staff
      def staff_ids
        staff_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for staff
      def staff_profiles
        affiliation_profiles('capStaff')
      end

      # @return ids [Array<Integer>] a profileId for each physician
      def physician_ids
        physician_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for physicians
      def physician_profiles
        affiliation_profiles('physician')
      end

      # @return ids [Array<Integer>] a profileId for each postdoc
      def postdoc_ids
        postdoc_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for postdocs
      def postdoc_profiles
        affiliation_profiles('capPostdoc')
      end

      # @return ids [Array<Integer>] a profileId for each md_student
      def md_student_ids
        md_student_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for md_students
      def md_student_profiles
        affiliation_profiles('capMdStudent')
      end

      # @return ids [Array<Integer>] a profileId for each ms_student
      def ms_student_ids
        ms_student_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for ms_students
      def ms_student_profiles
        affiliation_profiles('capMsStudent')
      end

      # @return ids [Array<Integer>] a profileId for each phd_student
      def phd_student_ids
        phd_student_profiles.map {|p| p['profileId'] }
      end
      # @return profiles [Array<Hash>] profiles for phd_students
      def phd_student_profiles
        affiliation_profiles('capPhdStudent')
      end

      # @return affiliations [Array<String>] the enum of affiliations
      def affiliations
        @affiliations ||= begin
          id = profile_ids.sample(1).first
          if id
            p = profile(id)
            p['affiliations'].keys
          else
            ["capFaculty", "capStaff", "capPostdoc", "capMdStudent", "capMsStudent", "capPhdStudent", "physician"]
          end
        rescue
          ["capFaculty", "capStaff", "capPostdoc", "capMdStudent", "capMsStudent", "capPhdStudent", "physician"]
        end
      end

      # @param affiliation [String] an item from the affiliations hash
      # @return profiles [Array<Hash>] profiles for physicians
      def affiliation_profiles(affiliation)
        if affiliations.include? affiliation
          q = {"affiliations.#{affiliation}" => true}
          mongo_profiles(q)
        else
          msg = "#{affiliation} is not in #{affiliations}"
          puts msg
          config.logger.warn msg
          []
        end
      end

      # Extract all the education organization names and return a unique
      # set of names, sorted alphabetically.  TODO: match the organization
      # names to authorities and/or ISNI/ORCID/VIAF identifiers? e.g. see
      # http://id.loc.gov/search/?q=Agricultural+University+Shandong&format=json
      # @return orgs [Array<String>] a set of the education institution names
      def education_org_names
        @education_org_names ||= begin
          edu = @profiles.find.projection({'_id' => 0, 'education' => 1})
          orgs = edu.map do |doc|
            # the 'education' field is an array
            edu = doc['education'] || []
            edu.map {|e| e['organization']}.flatten.compact
          end
          orgs.flatten.uniq.sort
        end
      end

      # Extract all the education degree names and return a unique
      # set of names, sorted alphabetically.
      def education_degrees
        @education_degree_names ||= begin
          edu = @profiles.find.projection({'_id' => 0, 'education' => 1})
          degrees = edu.map do |doc|
            # the 'education' field is an array
            edu = doc['education'] || []
            # edu.map {|e| education_parser(e)['degree']}.flatten.compact
            edu.map {|e| e['degree']}.flatten.compact
          end
          degrees.flatten.to_set.to_a.sort
        end
      end

      # Attempt to parse an education entry
      # @param education [Hash] an entry in the profile education array
      # @return education [Hash]
      def education_parser(edu)
        edu_out = edu
        degree = edu['degree']
        if degree.nil?
          # Sometimes the degree etc. is in the label
          label = edu['label']['text'] rescue ''
          degree = label.split(':').first || label.split(',').first
        end
        # There are a ton of non-normative strings that could be translated
        # to a normative form, but it's not yet clear how to do this well.
        # if degree
        #   degree = degree.split.map {|w| w.capitalize }.join(' ')
        #   edu_out['degree'] = degree.tr('.()-/','')
        # end
        edu_out['degree'] = degree if degree
        edu_out
      end

      # Run a mongo find on profiles with query doc
      # @param query_doc [Hash] profiles.find({query_doc})
      # @return profiles [Array<Hash>] profiles matching the query
      def mongo_profiles(query_doc)
        mongo_map_profile_ids @profiles.find(query_doc)
      end

      # Convert mongo '_id' to 'profileId'
      # @param profiles [Array<Hash>] mongo profiles with '_id'
      # @return profiles [Array<Hash>] mongo profiles with 'profileId'
      def mongo_map_profile_ids(profiles)
        profiles.map {|p| p['profileId'] = p.delete('_id'); p }
      end

      # Collect all the organization codes from profiles.
      # Saves organization codes into @org_codes
      # @param profile [Hash] CAP profile data
      def orgs_collect(profile)
        @org_codes ||= Set.new
        titles = profile['titles']
        if titles
          orgs = titles.map {|t| t['organization']['orgCode'] rescue nil }
          @org_codes = @org_codes.union orgs.compact
        end
      end

      # Process all the organization data
      def orgs_process
        @orgs_data = orgs_retrieve(@org_codes)
        @orgs_data.each {|o| org_save(o)}
      end

      def org_codes(org)
        codes = org['orgCodes'] || []
        if org['children']
          codes.push org['children'].map {|o| org_codes(o)}
        end
        codes.flatten.uniq
      end

      # Retrieve all the organization data in local repo
      # @param org_codes [Set<String>]
      def orgs_retrieve(org_codes)
        # try to load orgs data already saved
        path = File.dirname(File.absolute_path(__FILE__))
        file = File.join(path, 'orgs.json')
        orgs_data = JSON.load(File.open(file).read)  # array
        orgs_saved = orgs_data.map {|o| org_codes(o) }.flatten.to_set
        orgs2get = org_codes - orgs_saved
        begin
          params = '?orgCodes=' + orgs2get.to_a.join(',')
          response = @cap_api.get "#{@cap_orgs}#{params}"
          if response.status == 200
            orgs = response.body
            orgs_data.push orgs
            orgs_data.flatten!
            File.open(file,'w').write(JSON.dump(orgs_data))
          else
            msg = "Failed to request org data: #{response.body}"
            @config.logger.error msg
          end
        rescue => e
          msg = "Failed to request org data: #{e.message}"
          @config.logger.error msg
        end
        orgs_data
      end

      # Save the organization data in local repo
      def org_save(org)
        begin
          org.delete('browsable')
          org['orgCodes'].flatten!
          org['_id'] = org['alias']
          if org['children']
            org['children'].each {|o| org_save(o)}
            org.delete('children')
          end
          @orgs.insert_one(org)
        rescue => e
          msg = "Org #{org['alias']} failed to save: #{e.message}"
          @config.logger.error msg
        end
      end

      # return profile data from local repo
      # @param id [Integer] A profileId number
      # @return profile [Hash|nil]
      def profile(id)
        profile = @profiles.find({_id: id}).first
        if profile
          profile['profileId'] = profile.delete('_id')
          profile
        else
          msg = "Profile #{id} doesn't exist"
          @config.logger.warn msg
          {}
        end
      end

      # Remove privileged fields from profile data
      # @param profile [Hash] CAP profile data
      def profile_clean(profile)
        @@priv_fields ||= %w(uid universityId)
        if @config.clean
          @@priv_fields.each {|f| profile.delete(f)}
        end
      end

      # Save profile data in local repo
      # @param profile [Hash] CAP profile data
      def profile_save(profile)
        profile_clean(profile)
        # split out the publication data to accommodate size limit on mongo
        id = profile['profileId']
        profile['_id'] = id  # use 'profileId' as the mongo _id
        presentations = profile.delete('presentations') || []
        presentations_save(id, presentations)
        publications = profile.delete('publications') || []
        publications_save(id, publications)
        begin
          @profiles.insert_one(profile)
        rescue => e
          msg = "Profile #{id} failed to save: #{e.message}"
          @config.logger.error msg
        end
        begin
          process_update(profile)
        rescue => e
          msg = "Profile #{id}: failed to update process data: #{e.message}"
          @config.logger.error msg
        end
      end

      # return presentation data from local repo
      # @param id [Integer] A profileId number
      # @return presentations [Array<Hash>|nil]
      def presentation(id)
        @presentations.find({_id: id}).first
      end

      # Save presentation data in local repo (mongodb)
      # @param id [Integer] CAP profileId
      # @param presentations [Hash] CAP profile presentations data
      def presentations_save(id, presentations)
        presentations.each {|p| p.delete('detail')}
        pres = {'_id' => id, 'presentations' => presentations}
        begin
          @presentations.insert_one(pres)
        rescue => e
          msg = "Profile #{id} presentations failed to save: #{e.message}"
          @config.logger.error msg
        end
      end

      # return publication data from local repo
      # @param id [Integer] A profileId number
      def publication(id)
        @publications.find({_id: id}).first
      end

      # Save publications data in local repo (mongodb)
      # @param id [Integer] CAP profileId
      # @param publications [Array<Hash>] CAP profile publications data
      def publications_save(id, publications)
        @pubs_fields ||= [
          'doiId', 'doiUrl',
          'pubMedId', 'pubMedUrl',
          'publicationId',
          'type',
          'webOfScienceId', 'webOfScienceUrl'
        ]
        pubs = publications.map do |pub|
          pub.select{|k,v| @pubs_fields.include?(k) }
        end
        pubs = {'_id' => id, 'publications' => pubs}
        begin
          @publications.insert_one(pubs)
        rescue => e
          msg = "Profile #{id} publications failed to save: #{e.message}"
          @config.logger.error msg
        end
      end

      # A profile's processing data.
      # @param id [Integer] A profileId number
      # @return data [Hash] Processing information
      def process_data(id)
        @processed.find({_id: id}).first || {}
      end

      # Update a profile record with lastModified time and processing data.
      # @param profile [Hash] CAP profile
      def process_update(profile)
        id = profile['profileId']
        data = process_data(id)
        cap_modified = profile['lastModified'] || 0
        cap_modified = Time.parse(cap_modified).to_i
        data['cap_modified'] = cap_modified
        data['cap_retrieved'] = Time.now.to_i
        process_doc = {
          _id: id,
          lastModified: Time.now.to_i,
          data: data
        }
        @processed.insert_one(process_doc)
      end

      def repo_clean
        @orgs.drop
        @orgs.create
        @profiles.drop
        @profiles.create
        @presentations.drop
        @presentations.create
        @publications.drop
        @publications.create
        @processed.drop
        @processed.create
        puts "Cleared saved profiles."
      end

      # Search ORCID by publication DOI
      # Search the public ORCID API for records with an exact DOI, e.g.
      # curl -H "Accept: application/orcid+json" "http://pub.orcid.org/v1.2/search/orcid-bio/?q=digital-object-ids:%2210.1087/20120404%22"
      # @param doi [String] DOI like 10.1087/20120404
      def orcid_search_by_doi(doi)
        orcid_search_init
        query = '?q=digital-object-ids:' + doi
        response = @orcid_search_api.get query
        if response.status == 200
          search_results = JSON.parse(response.body)
          items = search_results['orcid-search-results']['orcid-search-result']
          orcid_profiles = items.map {|i| i['orcid-profile']}
          orcid_profiles.map do |p|
            uri = p['orcid-identifier']['uri']
            bio = p['orcid-bio']
            fn = bio['personal-details']['given-names']['value']
            ln = bio['personal-details']['family-name']['value']
            email = bio['contact-details']['email']
            orcid_data = {
              orcid_uri: uri,
              given_name: fn,
              last_name: ln,
              email: email,
            }
            # Scopus Author ID
            external_ids =  bio['external-identifiers']['external-identifier']
            scopus_ids = external_ids.select do |i|
              i['external-id-common-name']['value'].include? 'Scopus'
            end
            scopus_ids = scopus_ids.map {|i| i['external-id-reference']['value']}
            orcid_data[:scopus_ids] = scopus_ids
          end
        end
      end


      #############################################################
      private

      def repo_commit(total)
        index_names
        index_orgs
        index_affiliations
        puts "Stored #{@profiles.find.count} of #{total} profiles."
        puts "Stored profiles to #{@profiles.class} at: #{@profiles.namespace}."
      end

      def index_affiliations
        affiliations.each do |a|
          @profiles.indexes.create_one({"affiliation.#{a}" => 1})
        end
      end

      def index_names
        @profiles.indexes.create_one({'names.legal.firstName' => 1})
        @profiles.indexes.create_one({'names.legal.lastName'  => 1})
      end

      def index_orgs
        @orgs.indexes.create_one({'orgCodes' => 1})
      end

      def json_payloads
        { accept: JSON_CONTENT, content_type: JSON_CONTENT }
      end

      # Initialize a client for the ORCID search API
      def orcid_search_init
        @orcid_public_uri ||= 'http://pub.orcid.org/v1.2'
        @orcid_search_uri ||= @orcid_public_uri + '/search/orcid-bio/'
        @orcid_search_api ||= Faraday.new(url: @orcid_search_uri) do |f|
          # f.use FaradayMiddleware::FollowRedirects, limit: 3
          # f.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
          # f.request :logger, @config.logger
          f.request :json
          f.response :json, :content_type => JSON_CONTENT
          f.adapter Faraday.default_adapter
        end
        @orcid_search_api.options.timeout = 90
        @orcid_search_api.options.open_timeout = 10
        headers = { accept: 'application/orcid+json', content_type: JSON_CONTENT }
        @orcid_search_api.headers.merge!(headers)
      end


    end
  end
end
