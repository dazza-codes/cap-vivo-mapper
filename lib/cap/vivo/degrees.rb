module Cap
  module Vivo
    module Degrees

# The VIVO instance data for academic degrees is at
# https://github.com/vivo-project/VIVO/blob/develop/rdf/abox/filegraph/academicDegree.rdf
#
# I’m not aware of any structure provision for degree honor variations in VIVO-ISF
# — as Violeta indicates, information like that typically is added to the
# vivo:supplementalInformation data property as free text.
#
# We do have the vivo:majorFieldOfDegree property, both would have a
# vivo:AwardedDegree as the subject.  The AwardedDegree is a subclass of
# vivo:Relationship.
#
# Thanks,
# Jon <jc55@cornell.edu>


      # Resolve a degree string into a VIVO representation
      # @parameter degree [String] a degree designation
      # @return rdf [RDF::Graph]
      def degree_strings2things(degree)
        uri = degree_uri(degree)
        degree_graph(uri, degree)
        # case degree
        # when /fellow/i
        # when /postdoc/i
        # else
        # end
      end

      # # Find a degree by string
      # # @parameter degree [String] a degree designation
      # # @return rdf [RDF::Graph]
      # def degree_search(degree)
      #   query = "SELECT ?iri WHERE { ?iri a <#{RDF::VIVO.AcademicDegree}> "
      #   query += "; <#{RDF::SKOS.prefLabel}> ?prefLabel "
      #   query += "; <#{RDF::SKOS.altLabel}> ?altLabel ."
      #   query += "  FILTER ( ?altLabel == '#{degree}' ) "
      #   query += "}"
      #   q = SPARQL.parse(query)
      #   @@degree_graph.query(q)
      #   # use the found ?iri to DESCRIBE the graph
      # end

      # Create VIVO RDF for a degree
      # @parameter uri [RDF::URI]
      # @parameter label [String] a degree designation
      # @return rdf [RDF::Graph] with uri a vivo:AcademicDegree
      def degree_graph(uri, label)
        g = RDF::Graph.new
        g << [uri, RDF.type, RDF::VIVO.AcademicDegree]
        g << [uri, RDF::SKOS.altLabel, label]
        g
      end

      # Suggest academic degree acronyms for a degree description that may
      # contain many variations on degree identifiers; that is, attempt to
      # disambiguate a degree description, erring on the side of false
      # positive suggestions.  Among all the suggestions, there may be one
      # or two that are accurate.
      # @parameter degree [String] a degree designation
      # @return acronyms [Array<String>]
      def degree_acronyms(degree)

        # TODO: split the degree on any punctuation, except '.'

        # Find candidate degree labels that contain the degree description.
        # The degree labels are more authoritative than the degree abbreviations,
        # because some abbreviations match multiple labels (see the results in
        # vivo_degree_abbreviation_ambiguous).
        abbrevs = []
        if degree.length > 6
          # the degree might be spelled out, not just an acronym
          degree_words = wordset(degree.split)
          vivo_degree_wordsets.each_pair do |abbrev, words|
            # only match when all the vivo degree words are in degree
            i = words.intersection(degree_words)
            if i.length == words.length
              # Good, all the vivo words are in this degree description;
              # but the degree description could contain more words.
              if words.length == degree_words.length
                # This is an exact match, stop here.
                return [abbrev]
              else
                # This is a good candidate, although not an exact match.
                abbrevs.push(abbrev)
              end
            end
          end
        end
        # Find candidate degree acronyms in the degree description;
        # e.g. a='MA' and {k: v} = {'M.A.' => 'MA'}, return 'M.A.'
        # Match at the beginning or the end of the degree description.
        a = degree.gsub(/\W*/,'').upcase
        abbrevs.push vivo_degree_abbreviations.select {|k,v| a =~ /^#{v}|#{v}$/}.keys
        abbrevs.flatten.compact.uniq
      end

      # Create a URI for a degree string
      # @parameter degree [String] a degree designation
      # @return uri [RDF::URI]
      def degree_uri(degree)
        name = degree.gsub(/\W+/,'').downcase
        RDF::URI.parse "http://vivo.stanford.edu/degree/#{name}/"
      end

      def vivo_degrees
        @vivo_degrees ||= begin
          # Try to load the data locally
          g = RDF::Graph.new
          begin
            path = File.dirname(File.absolute_path(__FILE__))
            file = File.join(path, 'vivo_degrees.ttl')
            g = RDF::Graph.load(file)
          rescue
            g = RDF::Graph.load('https://raw.githubusercontent.com/vivo-project/VIVO/develop/rdf/abox/filegraph/academicDegree.rdf')
          end
          raise 'Failed to load VIVO degree graph' if g.empty?
          g
        end
      end

      # @return abbreviations [Hash] VIVO degree abbreviations
      def vivo_degree_abbreviations
        @vivo_degree_abbreviations ||= begin
          q = [nil, RDF::VIVO.abbreviation, nil]
          abbrevs = vivo_degrees.query(q).objects
          abbrevs.map {|o| [o.to_s, vivo_degree_acronym(o.to_s)] }.to_h
        end
      end

      # VIVO degree abbreviation in upper case without puntuation
      # @return acronym [String] VIVO degree acronym
      def vivo_degree_acronym(abbreviation)
        abbreviation.gsub(/\W+/,'').upcase
      end

      # VIVO degree abbreviations are not unique, so the degree label is
      # required to disambiguate these abbreviations.
      # Find all VIVO abbreviations that match more than one label
      def vivo_degree_abbreviation_ambiguous
        @vivo_degree_abbreviation_ambiguous ||= begin
          h = {}
          vivo_degree_abbreviations.keys.each do |a|
            # select all labels that use this abbreviation
            labels = vivo_degree_labels.select {|l| l.split.first == a }
            h[a] = labels if labels.length > 1
          end
          h
        end
      end

      # VIVO degree labels
      # @return labels [Array] VIVO degree labels with abbreviations
      def vivo_degree_labels
        @vivo_labels ||= begin
          q = [nil, RDF::RDFS.label, nil]
          labels = vivo_degrees.query(q).objects
          labels.map {|i| i.to_s }.sort
        end
      end

      # VIVO degree word sets are a hash with the degree abbreviation keys
      # and the values are significant words that identify the degree (lowercase)
      # The data structure can be used in analysis to disambiguate a degree label.
      # @return degree_wordsets [Hash<String:Set<String>>]
      def vivo_degree_wordsets
        @vivo_degree_wordsets ||= begin
          labels = vivo_degree_labels
          labels.map {|l| arr = l.split; [arr.first, wordset(arr[1..-1])]}.to_h
        end
      end

      # A hash of academic degrees {abbreviation: description};
      # the data is from an MIT web site, but not necessarily MIT degrees.
      # @return mit_degrees [Hash<String:String>]
      def mit_degrees
        @mit_degrees ||= begin
          degrees = "AA - Associate in Arts\nAB - Bachelor in Arts\nAE - Aeronautical Engineer\nAM - Master of Arts\nAS - Associate in Science\nAN - Associate in Nursing\nBAC - Bachelor of Accountancy\nBAR - Bachelor in Architecture\nBBA - Bachelor in Business Administration\nBCH - Bachelor of Chemistry\nBCP - Bachelor in City Planning\nBE - Building Engineer\nBEC - Bachelor of Economics\nBED - Bachelor of Education\nBFA - Bachelor of Fine Arts\nBO - Non Degree Bachelors\nBOC - Bachelor of Commerce\nBOE - Bachelor of Engineering\nBS - Bachelor of Science\nBSE - Bachelor of Engineering\nBTE - Bachelor of Technology\nBTS - Bachelor of Theological Studies\nCE - Civil Engineer\nCHE - Chemical Engineer\nCPH - Certificate of Public Health\nCSE - Engineering in Computer Science\nCTF - Certificate\nDBA - Doctor of Business Adminstration\nDDS - Doctor of Dental Science\nDIE - Diploma of Engineering\nDIP - Diploma\nDMD - Doctor of Medical Dentistry\nDO - Non Degree Doctorals\nDPH - Doctor of Public Health\nDSC - Doctor of Science\nDVM - Doctor of Veterinary Medicine\nEAA - Aeronautical & Astronautical Engineer\nEDU - Doctor of Education\nEE - Electrical Engineer\nEGD - Doctor of Engineering\nENE - Environmental Engineer\nENG - Engineer\nHM - Honorary Degree\nING - Engineering\nJD - Juris Doctor\nLLB - Bachelor of Laws\nLLD - Doctor of Laws\nLLM - Master of Laws\nMA - Master of Arts\nMAA - Master in Architecture Advanced Studies\nMAE - Materials Engineer\nMAR - Master of Architecture\nMAT - Master of Arts Teaching\nMBA - Masters in Business Administration\nMCP - Master in City Planning\nMD - Doctor of Medicine\nMDV - Master of Divinity\nME - Mechanical Engineer\nMEC - Master of Economics\nMED - Masters in Education\nMEE - Master of Mechnaical Engineering\nMEN - Master of Electrical Engineering\nMET - Meteorologist\nMFA - Master of Fine Arts\nMIE - Mineral Engineer\nMME - Marine Mechanical Engineer\nMMG - Master in Management\nMNG - Master of Engineering\nMO - Non Degree Master\nMPA - Master in Public Health Administration\nMPH - Master in Public Health\nMPL - Master in Patent Law\nMPP - Master of Public Policy\nMRE - Master of Research Development\nMS - Master of Science\nMSW - Master of Social Work\nMTE - Metallurgical Engineer\nMUD - Master of Urban Design\nMUP - Master of Urban Planning\nNA - Naval Architect\nNE - Naval Engineer\nNON - non degree\nNUE - Nuclear Engineer\nOCE - Ocean Engineer\nOD - Doctor of Optometry\nPHB - Bachelor of Philosophy\nPHC - Pharmaceutical Chemist\nPhD - Doctor of Philosophy\nPHM - Master of Philosophy\nPHS - Public Health Service\nSB - Bachelor of Science\nScD - Doctor of Science\nSE - Sanitary Engineer\nSM - Master of Science\n"
          degrees.split("\n").map{|d| d.split('-').map {|i| i.strip}}.to_h
        end
      end

      # MIT degree word sets are a hash with the degree abbreviation keys
      # and the values are significant words that identify the degree (lowercase)
      # The data structure can be used in analysis to disambiguate a degree label.
      # @return degree_wordsets [Hash<String:Set<String>>]
      def mit_degree_wordsets
        @mit_degree_wordsets ||= mit_degrees.map {|k,v| [k, wordset(v.split)]}.to_h
      end

      # Convert an array of words into a set of significant words
      # (minus nonwords).  Each word is converted to lower case.
      # @param words [Array<String>] an array of words
      # @return words [Set<String>] a set of lower case words - nonwords
      def wordset(words)
        words.map{|w| w.downcase.to_sym}.to_set - nonwords
      end

      # Words to be excluded from disambiguation analysis, like:
      # of, in, the, and
      # @return nonwords [Set<String>]
      def nonwords
        @nonwords ||= %w(& of in the and).map{|w| w.to_sym}.to_set
      end

    end
  end
end
