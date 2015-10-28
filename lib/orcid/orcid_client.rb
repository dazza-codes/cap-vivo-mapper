module Orcid
  module Client

    require 'faraday'
    require 'faraday_middleware'

    JSON_CONTENT = 'application/json'

    # ORCID search is documented at
    # http://members.orcid.org/api/tutorial-searching-api-12-and-earlier
    # http://members.orcid.org/api/tutorial-retrieve-data-public-api-curl-12-and-earlier
    # http://members.orcid.org/api/code-examples
    # http://members.orcid.org/finding-orcid-record-holders-your-institution
    # http://members.orcid.org/api/tutorial-searching-api-12-and-earlier

    attr_reader :orcid_search_api

    # Initialize a client for the ORCID search API
    def orcid_search_init
      @orcid_public_uri ||= 'http://pub.orcid.org/v1.2'
      @orcid_search_uri ||= @orcid_public_uri + '/search/orcid-bio/'
      @orcid_search_api ||= Faraday.new(url: @orcid_search_uri) do |conn|
        # conn.use FaradayMiddleware::FollowRedirects, limit: 3
        # conn.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
        # conn.request :logger, @config.logger
        conn.request :retry, max: 2, interval: 0.5,
                       interval_randomness: 0.5, backoff_factor: 2
        conn.request :json
        conn.response :json, :content_type => JSON_CONTENT
        conn.adapter :httpclient
      end
      @orcid_search_api.options.timeout = 90
      @orcid_search_api.options.open_timeout = 10
      headers = { accept: 'application/orcid+json', content_type: JSON_CONTENT }
      @orcid_search_api.headers.merge!(headers)
    end

    # Search ORCID by name
    # @param family_name [String]
    # @param given_name [String] optional
    # @return orcid_data [Array<Hash>]
    def orcid_search_by_name(family_name, given_name=nil)
      orcid_search_init
      query = '?q=family-name:' + family_name
      query += ' AND given-names:' + given_name if given_name
      response = @orcid_search_api.get query
      orcid_search_parse(response)
    end

    # Search ORCID by publication DOI
    # Search the public ORCID API for records with an exact DOI, e.g.
    # curl -H "Accept: application/orcid+json" "http://pub.orcid.org/v1.2/search/orcid-bio/?q=digital-object-ids:%2210.1087/20120404%22"
    # @param doi [String] DOI like 10.1087/20120404
    # @return orcid_data [Array<Hash>]
    def orcid_search_by_doi(doi)
      orcid_search_init
      query = '?defType=edismax&q=digital-object-ids:%22' + doi + ':%22'
      response = @orcid_search_api.get query
      orcid_search_parse(response)
    end

    # Search ORCID by pubmed ID
    # @param pmid [String]
    # @return orcid_data [Array<Hash>]
    def orcid_search_by_pmid(pmid)
      orcid_search_init
      query = '?q=pmid:' + pmid
      response = @orcid_search_api.get query
      orcid_search_parse(response)
    end

    # Parse an ORCID search response for key information.
    # @param response [Faraday::Response]
    # @return orcid_data [Hash] keys include:
    #         orcid_uri, given_name, last_name, email, scopus_ids
    def orcid_search_parse(response)
      orcid_data = []
      if response.status == 200
        search_results = JSON.parse(response.body)
        items = search_results['orcid-search-results']['orcid-search-result']
        orcid_profiles = items.map {|i| i['orcid-profile']}
        orcid_data = orcid_profiles.map do |p|
          orcid = {
            orcid_id:  p['orcid-identifier']['path'],
            orcid_uri: p['orcid-identifier']['uri']
          }
          bio = p['orcid-bio']
          orcid.merge!(orcid_names(bio))
          orcid.merge!(orcid_contacts(bio))
          orcid.merge!(orcid_scopus_ids(bio))
          orcid
        end
      end
      orcid_data
    end

    # Extract contact details from an ORCID profile
    # @param bio [Hash] from orcid_profile['orcid-bio']
    # @return contacts [Hash]
    def orcid_contacts(bio)
      contacts = {}
      email = bio['contact-details']['email'] rescue nil
      contacts[:email] = email if email
      contacts
    end

    # Extract names from an ORCID profile
    # @param bio [Hash] from orcid_profile['orcid-bio']
    # @return names [Hash]
    def orcid_names(bio)
      names = {
        given_name:  bio['personal-details']['given-names']['value'],
        family_name: bio['personal-details']['family-name']['value']
      }
      # "other-names"=>{"other-name"=>[{"value"=>"Fred J. Blog"}, {"value"=>"Fred John Blog"}]
      on = bio['personal-details']['other-names']['other-name'] rescue nil
      if on
        names[:other_names] = on.map {|n| n['value']}
      end
      names
    end

    # Extract Scopus Author ID from an ORCID profile
    # @param bio [Hash] from orcid_profile['orcid-bio']
    # @return scopus_ids [Hash]
    def orcid_scopus_ids(bio)
      scopus = {}
      scopus_ids = nil
      external_ids = bio['external-identifiers']['external-identifier'] rescue nil
      if external_ids
        ids = external_ids.select do |i|
          i['external-id-common-name']['value'].include? 'Scopus'
        end
        scopus_ids = ids.map {|i| i['external-id-reference']['value']}
      end
      scopus[:scopus_ids] = scopus_ids if scopus_ids
      scopus
    end

  end
end
