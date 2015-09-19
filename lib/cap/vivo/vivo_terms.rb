module Cap
  module Vivo
    module VivoTerms

      # The VIVO-ISF v1.6 uses an older version of VCARD than the
      # version currently in the RDF::Vocab library.  Define a few
      # custom URIs here for the older VCARD vocabulary.
      VCARD_PREFIX = RDF::URI.parse 'http://www.w3.org/2006/vcard/ns#'
      VCARD_givenName  = VCARD_PREFIX + 'givenName'
      VCARD_familyName = VCARD_PREFIX + 'familyName'

      HAS_CONTACT_INFO = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000028'
      CONTACT_INFO_FOR = RDF::URI.parse 'http://purl.obolibrary.org/obo/ARG_2000029'

    end
  end
end
