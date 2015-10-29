module Crossref
  module Client

    require 'faraday'
    require 'faraday_middleware'

    JSON_CONTENT  = 'application/json'
    JSON_CROSSREF = 'application/vnd.citationstyles.csl+json'

    attr_reader :crossref_api

    # Initialize a client for the CrossRef search API
    # http://crosscite.org/cn/
    def crossref_init
      @crossref_uri ||= 'http://data.crossref.org/'
      @crossref_api ||= Faraday.new(url: @crossref_uri) do |conn|
        # conn.use FaradayMiddleware::FollowRedirects, limit: 3
        # conn.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x
        # conn.request :logger, @config.logger
        conn.request :retry, max: 2, interval: 0.5,
                       interval_randomness: 0.5, backoff_factor: 2
        # conn.request :json
        # conn.response :json, :content_type => JSON_CONTENT
        conn.adapter :httpclient
      end
      @crossref_api.options.timeout = 90
      @crossref_api.options.open_timeout = 10
      headers = { accept: JSON_CROSSREF }
      @crossref_api.headers.merge!(headers)
    end

    # Search CrossRef by publication DOI
    # Search the public CrossRef API for records with an exact DOI, e.g.
    # curl -H "Accept: application/json" "http://data.crossref.org/10.1200%2FJCO.2015.62.2225"
    # @param doi [String] DOI like 10.1087/20120404
    # @return crossref_data [Hash|nil]
    def crossref_search_by_doi(doi)
      crossref_init
      response = @crossref_api.get doi
      crossref_parse(response)
    end

    # Parse a CrossRef response for key information.
    # @param response [Faraday::Response]
    # @return crossref_data [Hash|nil]
    def crossref_parse(response)
      if response.status == 200
        JSON.parse(response.body)
        # most useful fields:
        # author, title, subtitle,
        # issued['date-parts']
        # container-title, volume, issue, page
        # DOI, URL, ISSN
      else
        nil
      end
    end

  end
end
