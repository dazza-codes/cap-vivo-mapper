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
        # Cleanup the degree
        degree = degree.strip.gsub(/['"]/,'')
        # Find all the capital letters
        degree_caps = capitals(degree)
        abbrevs = []

        # TODO: evaluate ruby libraries for smart string handling, e.g.
        # http://flori.github.io/amatch/doc/index.html
        # https://github.com/diasks2/ruby-nlp
        # https://github.com/diasks2/ruby-nlp#text-similarity

        # Find candidate degree abbreviations in the degree description;
        # e.g. degree='MA' and {k: v} = {'M.A.' => 'MA'}, return 'M.A.'
        # Split the description on non-words (except '.'); take the first
        # two items and remove any non-word chars.  Most of the acronyms will
        # be capital letters in acros[0], but sometimes the acronym will be
        # in acros.join and rarely acros[1] will also be a degree acronym.
        acros = degree.split(/[^\w.]/)[0..1].map do |i|
          i.gsub!(/\W/,'')
          i.empty? ? nil : i
        end.compact
        vivo_degree_abbreviations.each do |k,v|
          abbrevs.push([99,k]) if acros[0] == v
          abbrevs.push([88,k]) if acros[1] == v
          abbrevs.push([77,k]) if acros.join =~ /^#{v}|#{v}$/
        end
        # Find candidate degree labels that contain the degree description.
        # The degree labels are more authoritative than the degree abbreviations,
        # because some abbreviations match multiple labels (see the results in
        # vivo_degree_abbreviation_ambiguous).
        degree_words = wordset(degree.split)
        vivo_degree_wordsets.each_pair do |abbrev, words|
          # only match when all the vivo degree words are in degree
          word_count = words.intersection(degree_words).length
          if word_count == degree_words.length
            # an exact match must be highly ranked
            abbrevs.push([99, abbrev])
          elsif word_count > 0
            abbrevs.push([word_count, abbrev])
          end
        end
        # Sort the results and choose the top 20 options.
        abbrevs = abbrevs.sort.reverse.map {|a| a[1] }[0..19].uniq
        # Filter the abbreviations based on how well they match the
        # capital letters in the degree description.
        abbrevs = abbrevs.map do |abbrev|
          # Count the number of capitals in the abbrev that are in the degree.
          caps = capitals(abbrev).chars
          if caps.length > degree_caps.length
            # Don't exceed the number of caps in the degree.
            []
          else
            counts = caps.map {|c| degree_caps.include?(c) ? 1 : 0 }
            if counts.include? 0
              # exclude any acronymn with a capital not in the degree.
              []
            else
              metric = counts.reduce(0,:+)
              [metric, abbrev]
            end
          end
        end
        # Sort the results and choose the top 3 options.
        abbrevs = abbrevs.sort.reverse.map {|a| a[1] }.compact[0..2]
      end

      # A VIVO degree prefix for Stanford
      # @return uri [RDF::URI] A VIVO degree prefix for Stanford
      def degree_prefix
        @degree_prefix ||= RDF::URI.parse "http://vivo.stanford.edu/degree/"
      end

      # Create a URI for a degree string
      # @parameter degree [String] a degree designation
      # @return uri [RDF::URI]
      def degree_uri(degree)
        name = degree.gsub(/\W+/,'').downcase
        RDF::URI.parse "http://vivo.stanford.edu/degree/#{name}/"
      end

      # A graph of academic degrees
      # @return rdf [RDF::Graph]
      def degrees_graph
        @degrees_graph ||= begin
          g = RDF::Graph.new
          mit_degrees.each do |acronym, description|
            uri = degree_prefix + acronym
            abbrev = acronym.chars.join('.') + '.'
            label = "#{abbrev} #{description}"
            g << [uri, RDF.type, RDF::VIVO.AcademicDegree]
            g << [uri, RDF::RDFS.label, label]
            g << [uri, RDF::SKOS.prefLabel, label]
            g << [uri, RDF::VIVO.abbreviation, abbrev]
            g << [uri, RDF::VIVO.abbreviation, acronym]
          end
          vivo_degree_labels.each do |label|
            abbrev = label.split.first
            acronym = abbrev.gsub(/\W/,'')
            uri = degree_prefix + acronym
            g << [uri, RDF.type, RDF::VIVO.AcademicDegree]
            g << [uri, RDF::RDFS.label, label]
            g << [uri, RDF::SKOS.prefLabel, label]
            g << [uri, RDF::VIVO.abbreviation, abbrev]
            g << [uri, RDF::VIVO.abbreviation, acronym]
          end
          harvard_degrees.each do |degree|
            abbrev = degree.first
            acronym = abbrev.gsub(/\W/,'')
            description_latin = degree[1]
            description_english = degree[2]
            label = "#{abbrev} #{description_english}"
            uri = degree_prefix + acronym
            g << [uri, RDF.type, RDF::VIVO.AcademicDegree]
            g << [uri, RDF::RDFS.label, label]
            g << [uri, RDF::SKOS.prefLabel, label]
            g << [uri, RDF::SKOS.altLabel, "#{abbrev} #{description_latin}"]
            g << [uri, RDF::VIVO.abbreviation, abbrev]
            g << [uri, RDF::VIVO.abbreviation, acronym]
          end
          g
        end
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

      # @return uris [Hash] VIVO degree uris
      def vivo_degree_uris
        @vivo_degree_uris || begin
          # define the uris using the abbreviations method where it can
          # gather both uris and abbreviations efficiently.
          vivo_degree_abbreviations
          @vivo_degree_uris
        end
      end

      # @return abbreviations [Hash] VIVO degree abbreviations
      def vivo_degree_abbreviations
        @vivo_degree_abbreviations || begin
          @vivo_degree_uris = {}
          @vivo_degree_abbreviations = {}
          q = [nil, RDF::VIVO.abbreviation, nil]
          results = vivo_degrees.query(q).statements
          results.each do |statement|
            uri = statement.subject
            abbrev = statement.object.to_s
            acronym = vivo_degree_acronym(abbrev)
            @vivo_degree_abbreviations[abbrev] = acronym
            @vivo_degree_uris[abbrev] = uri
          end
          @vivo_degree_abbreviations
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


      # There is an explanation of some acronyms and why they are used at
      # Harvard on this page:
      #
      #   http://www.harvard.edu/on-campus/commencement/degree-abbreviations
      #
      # Quoting their page:
      #
      # Some Harvard degree abbreviations appear to be backwards because they
      # follow the tradition of Latin degree names. The traditional
      # undergraduate degrees awarded by Harvard University are the A.B. and
      # S.B. The A.B. is an abbreviation of the Latin name for the Bachelor of
      # Arts (B.A.) degree “artium baccalaureus.” The S.B., Latin for “scientiae
      # baccalaureus,” is the Bachelor of Science (B.S.). Likewise A.M.,
      # equivalent to the Master of Arts (M.A.), is Latin for “artium magister”;
      # and S.M., equivalent to the Master of Science (M.S.), is Latin for
      # “scientiae magister.” The more recent A.L.M. (Master of Liberal Arts in
      # Extension Studies) degree translates to “magistri in artibus liberalibus
      # studiorum prolatorum.”
      #
      # Harvard does not write all degrees backwards, however. Ph.D. is an
      # abbreviation for the Latin “philosophiae doctor,” translated as “Doctor
      # of Philosophy.” M.D., Doctor of Medicine, stands for the Latin
      # “medicinae doctor.” J.D., Latin for “juris doctor,” is the Doctor of Law
      # degree.
      def harvard_degrees
        @harvard_degrees ||= begin
          degrees = <<-DEGREES
            A.M.       -         artium magister              -  Master of Arts
            Art.D.     -         artium doctor                -  Doctor of Arts
            D.D.       -         divinitatis doctor           -  Doctor of Divinity
            L.H.D.     -         litterarum humanorum doctor  -  Doctor of Humane Letters
            Litt.D.    -         litterarum doctor            -  Doctor of Letters
            L.T.D.     -         litterarum doctor            -  Doctor of Letters
            LL.D.      -         legum doctor                 -  Doctor of Laws
            Mus.D.     -         musicae doctor               -  Doctor of Music
            S.D.       -         scientiae doctor             -  Doctor of Science
            DEGREES
          degrees.split("\n").map {|d| d.strip.split(/\s+-\s+/)}
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

      # Extract a set of capital letters
      # @param string [String]
      # @return capitals [String] capital letters in string
      def capitals(string)
        string.gsub(/\W|[a-z_]/,'')
      end

    end
  end
end
