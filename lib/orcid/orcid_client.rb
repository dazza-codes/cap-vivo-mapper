module Orcid
  module Client

    require 'faraday'
    require 'faraday_middleware'

    JSON_CONTENT = 'application/json'


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
