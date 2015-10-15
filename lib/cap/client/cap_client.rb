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

      include Orcid::Client
      include Cap::MongoRepo

      JSON_CONTENT = 'application/json'

      attr_reader :config
      attr_reader :cap_api

      # Initialize a new client
      def initialize
        @config = Cap::Client.configuration
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
        begin
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
            true
          end
        rescue => e
          msg = "Failed to authenticate: #{e.message}"
          binding.pry if @config.debug
          @config.logger.error(msg)
        end
      end

      # Get a Stanford organization tree from CAP API and store into local repo
      def get_orgs
        begin
          if authenticate
            response = @cap_api.get '/cap/v1/orgs/stanford'
            if response.status == 200
              stanford_orgs = response.body
              orgs_file_save(stanford_orgs)
              org_save(stanford_orgs) # recursive
            else
              msg = "Failed to GET Stanford orgs: #{response.status}"
              @config.logger.error msg
              puts msg
            end
          end
        rescue => e
          msg = e.message
          binding.pry if @config.debug
          @config.logger.error(msg)
        end
      end

      # Get profiles from CAP API and store into local repo
      def get_profiles
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
                  profile_clean(profile)
                  # split out the publication data to accommodate size limit on mongo
                  id = profile['profileId']
                  profile['_id'] = id  # use 'profileId' as the mongo _id
                  pres = profile.delete('presentations') || []
                  presentations_save(id, pres)
                  pubs = profile.delete('publications') || []
                  publications_save(id, pubs)
                  profile_save(profile)
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
            puts "Processed #{total} profiles."
          rescue => e
            msg = e.message
            binding.pry if @config.debug
            @config.logger.error msg
          ensure
            repo_commit
          end
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


      # # Collect all the organization codes from profiles.
      # # Saves organization codes into @org_codes
      # # @param profile [Hash] CAP profile data
      # def orgs_collect(profile)
      #   @org_codes ||= Set.new
      #   titles = profile['titles']
      #   if titles
      #     orgs = titles.map {|t| t['organization']['orgCode'] rescue nil }
      #     @org_codes = @org_codes.union orgs.compact
      #   end
      # end

      # # Process all the organization data
      # def orgs_process
      #   @orgs_data = orgs_retrieve(@org_codes)
      #   @orgs_data.each {|o| org_save(o)}
      # end

      def org_codes(org)
        codes = org['orgCodes'] || []
        if org['children']
          codes.push org['children'].map {|o| org_codes(o)}
        end
        codes.flatten.uniq
      end

      # json data file for CAP orgs
      def orgs_file
        @orgs_file ||= begin
          path = File.dirname(File.absolute_path(__FILE__))
          File.join(path, 'orgs.json')
        end
      end

      # Save json data to orgs_file
      def orgs_file_save(orgs_data)
        File.open(orgs_file,'w').write(JSON.dump(orgs_data))
      end

      # Load json data from orgs_file
      def orgs_file_load
        JSON.load(File.open(orgs_file).read)
      end

      # Retrieve organization data from CAP API, by orgCode
      # @param org_codes [Set<String>]
      def orgs_retrieve(org_codes)
        # try to load orgs data already saved
        orgs_data = orgs_file_load
        orgs_saved = orgs_data.map {|o| org_codes(o) }.flatten.to_set
        orgs2get = org_codes - orgs_saved
        begin
          params = '?orgCodes=' + orgs2get.to_a.join(',')
          response = @cap_api.get "#{@cap_orgs}#{params}"
          if response.status == 200
            orgs = response.body
            orgs_data.push orgs
            orgs_data.flatten!
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
          # @orgs.insert_one(org)
          orgs.insert_one(org)
        rescue => e
          msg = "Org #{org['alias']} failed to save: #{e.message}"
          @config.logger.error msg
        end
      end

      # Search ORCID for an identifier matching profile
      # @param id [Integer] A profileId number
      # @return orcid_data [Array<Hash>]
      def orcid_search(profile)
        fn = profile['names']['legal']['firstName']
        ln = profile['names']['legal']['lastName']
        orcids = orcid_search_by_name(ln, fn)
        if orcids.empty?
          fn = profile['names']['preferred']['firstName']
          ln = profile['names']['preferred']['lastName']
          orcids = orcid_search_by_name(ln, fn)
        end
        orcids
        #   # Search ORCID by publication data?
        #   cap_pubs = profile['publications']
        #   cap_dois = cap_pubs.map {|p| p['doiId'] }.compact
        #   cap_dois.each do |doi|
        #     orcids = orcid_search_by_doi(doi)
        #     orcids.select do |orcid|
        #       # TODO: check whether any of these match this profile?
        #       # Try to match on last name, first name, email
        #       if orcid[:last_name] == ln
        #         if orcid[:given_name].include? fn
        #           # This is likely a match
        #           break
        #         end
        #       end
        #     end
        #   end
        # end
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
        begin
          # use 'profileId' as the mongo _id
          profile['_id'] = profile['profileId']
          profiles.insert_one(profile)
        rescue => e
          msg = "Profile #{profile['profileId']} failed to save: #{e.message}"
          @config.logger.error msg
        end
        begin
          process_init(profile)
        rescue => e
          msg = "Profile #{profile['profileId']}: failed to update process data: #{e.message}"
          @config.logger.error msg
        end
      end

      # Update profile data in local repo
      # @param profile [Hash] CAP profile data
      def profile_update(profile)
        begin
          profile['_id'] = profile['profileId']
          profiles.update_one({'_id' => profile['profileId']}, profile)
        rescue => e
          msg = "Profile #{profile['profileId']} failed to update: #{e.message}"
          @config.logger.error msg
        end
        begin
          process_update(profile)
        rescue => e
          msg = "Profile #{profile['profileId']}: failed to update process data: #{e.message}"
          @config.logger.error msg
        end
      end

      # Save presentation data in local repo (mongodb)
      # @param id [Integer] CAP profileId
      # @param pres [Hash] CAP profile presentations data
      def presentations_save(id, pres)
        pres.each {|p| p.delete('detail')}
        pres = {'_id' => id, 'presentations' => pres}
        begin
          presentations.insert_one(pres)
        rescue => e
          msg = "Profile #{id} presentations failed to save: #{e.message}"
          @config.logger.error msg
        end
      end

      # Save publications data in local repo (mongodb)
      # @param id [Integer] CAP profileId
      # @param pubs [Array<Hash>] CAP profile publications data
      def publications_save(id, pubs)
        @pubs_fields ||= [
          'doiId', 'doiUrl',
          'pubMedId', 'pubMedUrl',
          'publicationId',
          'type',
          'webOfScienceId', 'webOfScienceUrl'
        ]
        pubs = pubs.map do |pub|
          pub.select{|k,v| @pubs_fields.include?(k) }
        end
        pubs = {'_id' => id, 'publications' => pubs}
        begin
          publications.insert_one(pubs)
        rescue => e
          msg = "Profile #{id} publications failed to save: #{e.message}"
          @config.logger.error msg
        end
      end

      # Update a profile record with lastModified time and processing data.
      # @param profile [Hash] CAP profile
      def process_init(profile)
        id = profile['profileId']
        cap_modified = profile['lastModified'] || 0
        cap_modified = Time.parse(cap_modified).to_i
        doc = {
          _id: id,
          lastModified: Time.now.to_i,
          cap_modified: cap_modified,
          cap_retrieved: Time.now.to_i
        }
        processed.insert_one(doc)
      end

      # Update a profile record with lastModified time and processing data.
      # @param profile [Hash] CAP profile
      def process_update(profile)
        id = profile['profileId']
        doc = process_doc(id)
        doc['lastModified'] = Time.now.to_i,
        processed.update_one({'_id' => id}, doc)
      end


      #############################################################
      private

      def json_payloads
        { accept: JSON_CONTENT, content_type: JSON_CONTENT }
      end

    end
  end
end
