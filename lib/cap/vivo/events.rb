module Cap
  module Vivo
    module Events

      # Resolve an organization name into a VIVO representation
      # @parameter org_name [String] an organization name
      # @return vivo_rdf [RDF::Graph]
      def event_strings2things(event_name)
        case event_name
        when /conference/i
          vivo_conference_event(event_name)
        else
          vivo_unknown_event(event_name)
        end
      end

      # <option selected="" value="">Select type</option>
      # <option value="http://vivoweb.org/ontology/core#Competition">Competition</option>
      # <option value="http://purl.org/ontology/bibo/Conference">Conference</option>
      # <option value="http://vivoweb.org/ontology/core#ConferenceSeries">Conference Series</option>
      # <option value="http://vivoweb.org/ontology/core#Course">Course</option>
      # <option value="http://purl.org/NET/c4dm/event.owl#Event">Event</option>
      # <option value="http://vivoweb.org/ontology/core#EventSeries">Event Series</option>
      # <option value="http://vivoweb.org/ontology/core#Exhibit">Exhibit</option>
      # <option value="http://purl.org/ontology/bibo/Hearing">Hearing</option>
      # <option value="http://purl.org/ontology/bibo/Interview">Interview</option>
      # <option value="http://vivoweb.org/ontology/core#InvitedTalk">Invited Talk</option>
      # <option value="http://vivoweb.org/ontology/core#Meeting">Meeting</option>
      # <option value="http://purl.org/ontology/bibo/Performance">Performance</option>
      # <option value="http://vivoweb.org/ontology/core#Presentation">Presentation</option>
      # <option value="http://vivoweb.org/ontology/core#SeminarSeries">Seminar Series</option>
      # <option value="http://purl.org/ontology/bibo/Workshop">Workshop</option>
      # <option value="http://vivoweb.org/ontology/core#WorkshopSeries">Workshop Series</option>

      def vivo_conference_event(name)
      end

      def vivo_unknown_event(name)
      end

    end
  end
end
