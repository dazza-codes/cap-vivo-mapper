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

      # Guess the acronym for a degree string
      # @parameter degree [String] a degree designation
      # @return acronym [String]
      def degree_acronym(degree)
        # TODO: exploring parsing the degree for an abbreviation
        # degrees.map {|d| a = /.\. .*\./.match(d); b = a ? a.to_s.gsub(/[ ]/,'') : d.split.first; [b, d] }
        # get the first word from the degree, which is often the
        # degree abbreviation (in some form)
        m = /.[. ]+.*\./.match(degree)
        abbr = m ? m.to_s.gsub(/[ ]/,'') : degree.split.first
        abbr = abbr.chomp('.') + '.'
        # This might be an acronym already, is it a VIVO degree?
        return abbr if vivo_degree_abbreviations.key? abbr
        if abbr.length <= 6
          # remove all punctuation and capitalize
          acro = abbr.gsub(/\W+/,'').upcase
          if vivo_degree_abbreviations.value? acro
            matches = vivo_degree_abbreviations.select {|k,v| v == acro }.keys
            return matches.first if matches.length == 1
            # TODO: figure out what to do with this?
            # The abbreviation might match multiple labels, so better check the
            # vivo_degree_abbreviation_ambiguous
          end
          # nasty little hack, might work sometimes.
          # return acro.chars.join('.') + '.'
        else
          # this might be a full title
        end
        nil  # shoot!
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
          h = {}
          q = [nil, RDF::VIVO.abbreviation, nil]
          a = vivo_degrees.query(q).objects.to_a
          a.each {|i| s = i.to_s; h[s] = vivo_degree_acronym(s) }
          h
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
          vivo_degree_abbreviations.keys.map do |a|
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
          a = vivo_degrees.query(q).objects.to_a
          a.map {|i| i.to_s }.sort
        end
      end

    end
  end
end
