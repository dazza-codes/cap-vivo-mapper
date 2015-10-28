require 'mongo'

module Cap
  module MongoRepo

    # Create a repository for storing CAP API json data
    def cap_repo_mongo
      @cap_repo_mongo ||= begin
        cap_mongo_logger
        repo = ENV['CAP_REPO_MONGO'].dup || 'mongodb://127.0.0.1:27017/cap'
        Mongo::Client.new(repo)
      end
    end

    def cap_mongo_logger
      @cap_mongo_logger ||= begin
        require 'logger'
        begin
          log_file = ENV['CAP_LOG_FILE'] || 'log/cap_repo_mongo.log'
          @log_file = File.absolute_path log_file
          FileUtils.mkdir_p File.dirname(@log_file) rescue nil
          log_dev = File.new(@log_file, 'w+')
        rescue
          log_dev = $stderr
          @log_file = 'STDERR'
        end
        log_dev.sync = true if @debug # skip IO buffering in debug mode
        logger = Logger.new(log_dev, 'weekly')
        logger.level = @debug ? Logger::DEBUG : Logger::INFO
        Mongo::Logger.logger = logger
        logger
      end
    end


    #######################################
    # Collections

    def orgs
      @orgs ||= cap_repo_mongo[:orgs]
    end

    def profiles
      @profiles ||= cap_repo_mongo[:profiles]
    end

    def presentations
      @presentations ||= cap_repo_mongo[:presentations]
    end

    def publications
      @publications ||= cap_repo_mongo[:publications]
    end

    def processed
      @processed ||= cap_repo_mongo[:processed]
    end


    #######################################
    # Core collection queries

    # return organization data from local repo
    # @param id [String] An organization alias
    # @return org [Hash|nil]
    def org_doc(id)
      org = orgs.find({_id: id}).first
      if org
        org
      else
        msg = "Organization #{id} doesn't exist"
        cap_mongo_logger.warn msg
        {}
      end
    end

    # return all organization data from local repo
    # @return orgs [Array<Hash>]
    def org_docs
      orgs.find.to_a
    end

    # return all organization codes from local repo
    # @return orgs [Array<String>]
    def org_codes
      orgs.find.map {|o| o['orgCodes']}.flatten.uniq.sort
    end

    # return all organization codes mapped to aliases
    # @return codes2aliases [Hash] code: alias
    def org_codes2aliases
      p = {'_id'=>0, 'alias'=>1, 'orgCodes'=>1}
      codes2aliases = {}
      orgs.find.projection(p).each do |o|
        o['orgCodes'].each {|c| codes2aliases[c] = o['alias'] }
      end
      codes2aliases
    end

    # return organization data from local repo
    # @param code [String] An organization code
    # @return org [Hash|nil] CAP organization data
    def org_by_code(code)
      # Investigation revealed that each orgCode maps to a unique organization;
      # although each organization can have multiple orgCode values.
      q = {'orgCodes' => {'$eq' => code}}
      org = orgs.find(q).first
      if org
        org
      else
        msg = "Organization #{code} doesn't exist"
        cap_mongo_logger.warn msg
        {}
      end
    end

    # Find organization alias for an orgCode
    # @param code [String] An organization code
    # @return org [Hash|nil] CAP organization alias
    def org_alias4code(code)
      p = {'_id'=>0, 'alias'=>1}
      q = {'orgCodes' => {'$eq' => code}}
      org = orgs.find(q).projection(p).first
      if org
        org['alias']
      else
        msg = "Organization #{code} doesn't exist"
        cap_mongo_logger.warn msg
        {}
      end
    end

    # @return ids [Array<Integer>] profile ids from local repo
    def profile_id_proj
      @profile_id_proj ||= {_id: false, profileId: true}
    end

    # @return ids [Array<Integer>] profile ids from local repo
    def profile_ids
      ids = profiles.find.projection(profile_id_proj)
      ids.map {|i| i['profileId']}
    end

    # return profile data from local repo
    # @param id [Integer] A profileId number
    # @return profile [Hash|nil]
    def profile_doc(id)
      profiles.find({_id: id}).first
    end

    # return all profile data from local repo
    # @return profiles [Array<Hash>]
    def profile_docs
      profiles.find.to_a
    end

    # return presentation data for one profile from local repo
    # @param id [Integer] A profileId number
    # @return presentations [Hash|nil]
    def presentation_doc(id)
      presentations.find({_id: id}).first
    end

    # return all presentation data from local repo
    # @return presentations [Array<Hash>]
    def presentation_docs
      presentations.find.to_a
    end

    # return publication data for one profile from local repo
    # @param id [Integer] A profileId number
    # @return publications [Hash|nil]
    def publication_doc(id)
      publications.find({_id: id}).first
    end

    # return all publication data from local repo
    # @return publications [Array<Hash>]
    def publication_docs
      publications.find.to_a
    end

    # A profile's processing data.
    # @param id [Integer] A profileId number
    # @return data [Hash] Processing information
    def process_doc(id)
      processed.find({_id: id}).first
    end


    #######################################
    # Affiliations

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
    # @param ids [Boolean] true: return only profileId; default=false
    # @return profiles [Array<Hash>] profiles for physicians
    def affiliation_profiles(affiliation, ids=false)
      if affiliations.include? affiliation
        q = {"affiliations.#{affiliation}" => true}
        if ids
          ids = profiles.find(q).projection(profile_id_proj)
          ids.map {|i| i['profileId']}
        else
          profiles.find(q)
        end
      else
        msg = "#{affiliation} is not in #{affiliations}"
        puts msg
        cap_mongo_logger.warn msg
        []
      end
    end

    # @return ids [Array<Integer>] a profileId for each faculty
    def faculty_ids
      # faculty_profiles.map {|p| p['profileId'] }
      affiliation_profiles('capFaculty', true)
    end
    # @return profiles [Array<Hash>] profiles for faculty
    def faculty_profiles
      affiliation_profiles('capFaculty')
    end

    # @return ids [Array<Integer>] a profileId for each staff
    def staff_ids
      # staff_profiles.map {|p| p['profileId'] }
      affiliation_profiles('capStaff', true)
    end
    # @return profiles [Array<Hash>] profiles for staff
    def staff_profiles
      affiliation_profiles('capStaff')
    end

    # @return ids [Array<Integer>] a profileId for each physician
    def physician_ids
      # physician_profiles.map {|p| p['profileId'] }
      affiliation_profiles('physician', true)
    end
    # @return profiles [Array<Hash>] profiles for physicians
    def physician_profiles
      affiliation_profiles('physician')
    end

    # @return ids [Array<Integer>] a profileId for each postdoc
    def postdoc_ids
      # postdoc_profiles.map {|p| p['profileId'] }
      affiliation_profiles('capPostdoc', true)
    end
    # @return profiles [Array<Hash>] profiles for postdocs
    def postdoc_profiles
      affiliation_profiles('capPostdoc')
    end

    # @return ids [Array<Integer>] a profileId for each md_student
    def md_student_ids
      # md_student_profiles.map {|p| p['profileId'] }
      affiliation_profiles('capMdStudent', true)
    end
    # @return profiles [Array<Hash>] profiles for md_students
    def md_student_profiles
      affiliation_profiles('capMdStudent')
    end

    # @return ids [Array<Integer>] a profileId for each ms_student
    def ms_student_ids
      # ms_student_profiles.map {|p| p['profileId'] }
      affiliation_profiles('capMsStudent', true)
    end
    # @return profiles [Array<Hash>] profiles for ms_students
    def ms_student_profiles
      affiliation_profiles('capMsStudent')
    end

    # @return ids [Array<Integer>] a profileId for each phd_student
    def phd_student_ids
      # phd_student_profiles.map {|p| p['profileId'] }
      affiliation_profiles('capPhdStudent', true)
    end
    # @return profiles [Array<Hash>] profiles for phd_students
    def phd_student_profiles
      affiliation_profiles('capPhdStudent')
    end


    #######################################
    # Education

    # Extract all the education organization names and return a unique
    # set of names, sorted alphabetically.  TODO: match the organization
    # names to authorities and/or ISNI/ORCID/VIAF identifiers? e.g. see
    # http://id.loc.gov/search/?q=Agricultural+University+Shandong&format=json
    # @return orgs [Array<String>] a set of the education institution names
    def education_org_names
      @education_org_names ||= begin
        edu = profiles.find.projection({'_id' => 0, 'education' => 1})
        orgs = edu.map do |doc|
          # the 'education' field is an array
          arr = doc['education'] || []
          arr.map {|e| e['organization']}.flatten.compact
        end
        orgs.flatten.uniq.sort
      end
    end

    # Extract all the education degree names and return a unique
    # set of names, sorted alphabetically.
    def education_degrees
      @education_degree_names ||= begin
        edu = profiles.find.projection({'_id' => 0, 'education' => 1})
        degrees = edu.map do |doc|
          # the 'education' field is an array
          arr = doc['education'] || []
          # arr.map {|e| education_parser(e)['degree']}.flatten.compact
          arr.map {|e| e['degree']}.flatten.compact
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


    #######################################
    # ORCID

    # Find all the profiles with ORCID data in the local repo
    # @return profiles [Array<Hash>] array of profiles with ORCID data
    def orcid_profiles
      q = {'orcidData' => {'$exists' => true, '$not' => {'$size' => 0}} }
      profiles.find(q).to_a
    end


    #######################################
    # Admin Utilities

    def repo_clean
      orgs.drop
      orgs.create
      profiles.drop
      profiles.create
      presentations.drop
      presentations.create
      publications.drop
      publications.create
      processed.drop
      processed.create
      puts "Cleared saved profiles."
    end

    def repo_commit
      mongo_index_affiliations
      mongo_index_names
      mongo_index_orgs
      puts "Stored #{profiles.find.count} profiles."
      puts "Stored profiles to #{profiles.class} at: #{profiles.namespace}."
    end

    def mongo_index_affiliations
      affiliations.each do |a|
        profiles.indexes.create_one({"affiliation.#{a}" => 1})
      end
    end

    def mongo_index_names
      profiles.indexes.create_one({'names.legal.firstName' => 1})
      profiles.indexes.create_one({'names.legal.lastName'  => 1})
      profiles.indexes.create_one({'names.preferred.firstName' => 1})
      profiles.indexes.create_one({'names.preferred.lastName'  => 1})
    end

    def mongo_index_orgs
      orgs.indexes.create_one({'orgCodes' => 1})
    end

  end
end
