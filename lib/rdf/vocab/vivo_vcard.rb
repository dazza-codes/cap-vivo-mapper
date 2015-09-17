# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from lib/rdf/vocab/vivo_vcard.owl
require 'rdf'
module RDF
  class VIVO_VCARD < RDF::StrictVocabulary("http://www.w3.org/2006/vcard/ns#")

    # Class definitions
    term :Acquaintance,
      label: "Acquaintance".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Address,
      comment: %(To specify the components of the delivery address for the vCard object).freeze,
      label: "Address".freeze,
      subClassOf: "vcard:Addressing".freeze,
      type: "owl:Class".freeze
    term :Addressing,
      comment: %(These types are concerned with information related to the delivery addressing or label for the vCard object).freeze,
      label: "Addressing".freeze,
      type: "owl:Class".freeze
    term :Agent,
      label: "Agent".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Calendar,
      label: "Calendar".freeze,
      type: "owl:Class".freeze
    term :CalendarBusy,
      comment: %(To specify the URI for the busy time associated with the object that the vCard represents.
Was called FBURI in vCard).freeze,
      label: "Calendar Busy".freeze,
      subClassOf: "vcard:Calendar".freeze,
      type: "owl:Class".freeze
    term :CalendarLink,
      comment: %(To specify the URI for a calendar associated with the object represented by the vCard.
Was called CALURI in vCard.).freeze,
      label: "CalendarLink".freeze,
      subClassOf: "vcard:Calendar".freeze,
      type: "owl:Class".freeze
    term :CalendarRequest,
      comment: %(To specify the calendar user address [RFC5545] to which a scheduling request [RFC5546] should be sent for the object represented by the vCard. 
Was called CALADRURI in vCard).freeze,
      label: "CalendarRequest".freeze,
      subClassOf: "vcard:Calendar".freeze,
      type: "owl:Class".freeze
    term :Category,
      comment: %(To specify application category information about the vCard, also known as tags. This was called CATEGORIES in vCard.).freeze,
      label: "Category".freeze,
      subClassOf: "vcard:Explanatory".freeze,
      type: "owl:Class".freeze
    term :Cell,
      comment: %(Also called mobile telephone).freeze,
      label: "Cell".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Child,
      label: "Child".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Code,
      comment: %(Contains all the Code related Classes that are used to indicate vCard Types).freeze,
      label: "Code".freeze,
      type: "owl:Class".freeze
    term :Colleague,
      label: "Colleague".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Communication,
      comment: %(These properties describe information about how to communicate with the object the vCard represents).freeze,
      label: "Communication".freeze,
      type: "owl:Class".freeze
    term :Contact,
      label: "Contact".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Coresident,
      label: "Coresident".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Coworker,
      label: "Coworker".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Crush,
      label: "Crush".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Date,
      label: "Date".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Email,
      comment: %(To specify the electronic mail address for communication with the object the vCard represents).freeze,
      label: "Email".freeze,
      subClassOf: "vcard:Communication".freeze,
      type: "owl:Class".freeze
    term :Emergency,
      label: "Emergency".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Explanatory,
      comment: %(These properties are concerned with additional explanations, such as that related to informational notes or revisions specific to the  vCard).freeze,
      label: "Explanatory".freeze,
      type: "owl:Class".freeze
    term :Fax,
      label: "Fax".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Female,
      label: "Female".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :FormattedName,
      comment: %(Specifies the formatted text corresponding to the name of the object the vCard represents).freeze,
      label: "Formatted Name".freeze,
      subClassOf: "vcard:Identification".freeze,
      type: "owl:Class".freeze
    term :Friend,
      label: "Friend".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Gender,
      label: "Gender".freeze,
      subClassOf: "vcard:Code".freeze,
      type: "owl:Class".freeze
    term :Geo,
      comment: %(Used to indicate global positioning  information that is specific to an address).freeze,
      label: "Geo".freeze,
      subClassOf: "vcard:Geographical".freeze,
      type: "owl:Class".freeze
    term :Geographical,
      comment: %(These properties are concerned with information associated with  geographical positions or regions associated with the object the vCard represents).freeze,
      label: "Geographical".freeze,
      type: "owl:Class".freeze
    term :Group,
      comment: %(Defines all the properties required to be a Group of Individuals or  Organizations).freeze,
      label: "Group".freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :Home,
      comment: %(This implies that the property is related to an individual's personal life).freeze,
      label: "Home".freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Identification,
      comment: %(These types are used to capture information associated with the identification and naming of the entity associated with the vCard).freeze,
      label: "Identification".freeze,
      type: "owl:Class".freeze
    term :Individual,
      comment: %(Defines all the properties required to be an Individual).freeze,
      label: "Individual".freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :InstantMessage,
      comment: %(To specify the URI for instant messaging and presence protocol communications with the object the vCard represents. 
Was called IMPP in vCard.).freeze,
      label: "Messaging".freeze,
      subClassOf: "vcard:Communication".freeze,
      type: "owl:Class".freeze
    term :Key,
      label: "Key".freeze,
      subClassOf: "vcard:Security".freeze,
      type: "owl:Class".freeze
    term :Kin,
      label: "Kin".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Kind,
      comment: %(The parent class for all vCard Objects).freeze,
      label: "VCard Kind".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/ARG_2000379".freeze,
      type: "owl:Class".freeze
    term :Language,
      comment: %(To specify the language\(s\) that may be used for contacting the entity associated with the vCard.).freeze,
      label: "Language".freeze,
      subClassOf: "vcard:Communication".freeze,
      type: "owl:Class".freeze
    term :Location,
      comment: %(Defines all the properties required to be a Location).freeze,
      label: "Location".freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :Logo,
      comment: %(To specify a graphic image of a logo associated with the  object the vCard represents).freeze,
      label: "Logo".freeze,
      subClassOf: "vcard:Organizational".freeze,
      type: "owl:Class".freeze
    term :Male,
      label: "Male".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Me,
      label: "Me".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Met,
      label: "Met".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Muse,
      label: "Muse".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Name,
      comment: %(Specifies the components of the name of the object the  vCard represents).freeze,
      label: "Name".freeze,
      subClassOf: "vcard:Identification".freeze,
      type: "owl:Class".freeze
    term :Neighbor,
      label: "Neighbor".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Nickname,
      comment: %(Specifies the text corresponding to the nickname of the object the vCard represents).freeze,
      label: "Nickname".freeze,
      subClassOf: "vcard:Identification".freeze,
      type: "owl:Class".freeze
    term :None,
      label: "None".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Note,
      comment: %(To specify supplemental information or a comment that is associated with the vCard).freeze,
      label: "Note".freeze,
      subClassOf: "vcard:Explanatory".freeze,
      type: "owl:Class".freeze
    term :Organization,
      comment: [%(Defines all the properties required to be an  Organization).freeze, %(To specify the organizational name  associated with the vCard).freeze],
      label: "Organization".freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :OrganizationName,
      label: "Organization Name".freeze,
      subClassOf: "vcard:Organizational".freeze,
      type: "owl:Class".freeze
    term :OrganizationUnitName,
      label: "OrganizationUnitName".freeze,
      subClassOf: "vcard:OrganizationName".freeze,
      type: "owl:Class".freeze
    term :Organizational,
      comment: %(These properties are concerned with information associated with characteristics of the organization or organizational units of the object that the vCard represents).freeze,
      label: "Organizational".freeze,
      type: "owl:Class".freeze
    term :Other,
      label: "Other".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Pager,
      label: "Pager".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Parent,
      label: "Parent".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Photo,
      comment: %(Specifies an image or photograph information that annotates some aspect of the object the vCard represents).freeze,
      label: "Photo".freeze,
      subClassOf: "vcard:Identification".freeze,
      type: "owl:Class".freeze
    term :Related,
      comment: %(To specify a relationship between another entity and the entity represented by this vCard).freeze,
      label: "Related".freeze,
      subClassOf: "vcard:Organizational".freeze,
      type: "owl:Class".freeze
    term :RelatedType,
      label: "Relation Type".freeze,
      subClassOf: "vcard:Code".freeze,
      type: "owl:Class".freeze
    term :Security,
      comment: %(Contains all the Security related Classes).freeze,
      label: "Security".freeze,
      type: "owl:Class".freeze
    term :Sibling,
      label: "Sibling".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Sound,
      comment: %(To specify a digital sound content information that annotates some aspect of the vCard.  This property is often used to specify the proper pronunciation of the name property value of the vCard).freeze,
      label: "Sound".freeze,
      subClassOf: "vcard:Explanatory".freeze,
      type: "owl:Class".freeze
    term :Spouse,
      label: "Spouse".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Sweetheart,
      label: "Sweetheart".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Telephone,
      label: "Telephone".freeze,
      subClassOf: "vcard:Communication".freeze,
      type: "owl:Class".freeze
    term :TelephoneType,
      label: "Telephone Type".freeze,
      subClassOf: "vcard:Code".freeze,
      type: "owl:Class".freeze
    term :Text,
      comment: %(Also called sms telephone).freeze,
      label: "Text".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :TextPhone,
      label: "Text Phone".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :TimeZone,
      comment: %(Used to indicate time zone information that is specific to a location or address).freeze,
      label: "Time Zone".freeze,
      subClassOf: "vcard:Geographical".freeze,
      type: "owl:Class".freeze
    term :Title,
      comment: %(To specify the position or job of the object the vCard represents).freeze,
      label: "Title".freeze,
      subClassOf: "vcard:Organizational".freeze,
      type: "owl:Class".freeze
    term :Type,
      comment: %(This is called TYPE in vCard but renamed here to Context for less confusion \(with types/class\)).freeze,
      label: "Type".freeze,
      subClassOf: "vcard:Code".freeze,
      type: "owl:Class".freeze
    term :URL,
      comment: %(To specify a uniform resource locator associated with the object to which the vCard refers.  Examples for individuals include personal web sites, blogs, and social networking site  identifiers. ).freeze,
      label: "URL".freeze,
      subClassOf: "vcard:Explanatory".freeze,
      type: "owl:Class".freeze
    term :Unknown,
      label: "Unknown".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Video,
      label: "Video".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Voice,
      label: "Voice".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Work,
      comment: %(This implies that the property is related to an individual's work place).freeze,
      label: "Work".freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze

    # Property definitions
    property :additionalName,
      domain: "vcard:Name".freeze,
      label: "additional name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :anniversary,
      comment: %(The date of marriage, or equivalent, of the object the  vCard represents).freeze,
      domain: "vcard:Individual".freeze,
      label: "anniversary".freeze,
      range: "xsd:dateTime".freeze,
      type: "owl:DatatypeProperty".freeze
    property :birthdate,
      comment: %(To specify the birth date of the object the vCard represents).freeze,
      domain: "vcard:Individual".freeze,
      label: "birthdate".freeze,
      range: "xsd:dateTime".freeze,
      type: "owl:DatatypeProperty".freeze
    property :calendarBusy,
      domain: "vcard:CalendarBusy".freeze,
      label: "calendar busy".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :calendarLink,
      domain: "vcard:CalendarLink".freeze,
      label: "calendar link".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :calendarRequest,
      domain: "vcard:CalendarRequest".freeze,
      label: "calendar request".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :category,
      domain: "vcard:Category".freeze,
      label: "category".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :country,
      domain: "vcard:Address".freeze,
      label: "country".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :email,
      domain: "vcard:Email".freeze,
      label: "email".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :familyName,
      comment: %(Called Family Name in vCard).freeze,
      domain: "vcard:Name".freeze,
      label: "familyName".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :formattedName,
      domain: "vcard:FormattedName".freeze,
      label: "has formatted name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :gender,
      comment: %(To specify the components of the sex and gender identity of the object the vCard represents.
To enable other Gender/Sex codes to be used, this dataproperty has range URI. The vCard gender code classes are defined under Code/Gender).freeze,
      domain: "vcard:Individual".freeze,
      label: "gender".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :geo,
      comment: %(Must use the geo URI scheme RFC5870).freeze,
      domain: "vcard:Geo".freeze,
      label: "geo".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :givenName,
      comment: %(called Given Name invCard).freeze,
      domain: "vcard:Name".freeze,
      label: "first name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :hasAddress,
      label: "has address".freeze,
      range: "vcard:Address".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCalendarLink,
      label: "has calendar link".freeze,
      range: "vcard:CalendarLink".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCalendarRequest,
      label: "has calendar request".freeze,
      range: "vcard:CalendarRequest".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCalenderBusy,
      label: "has calendar busy".freeze,
      range: "vcard:CalendarBusy".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCategory,
      label: "has category".freeze,
      range: "vcard:Category".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasEmail,
      label: "has email".freeze,
      range: "vcard:Email".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasFormattedName,
      label: "has formatted name".freeze,
      range: "vcard:FormattedName".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasGeo,
      label: "has geo".freeze,
      range: "vcard:Geo".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasInstantMessage,
      label: "hasInstantMessage".freeze,
      range: "vcard:InstantMessage".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasKey,
      label: "has key".freeze,
      range: "vcard:Key".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLanguage,
      label: "has language".freeze,
      range: "vcard:Language".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLogo,
      label: "has logo".freeze,
      range: "vcard:Logo".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasMember,
      comment: %(To include a member in the group this vCard represents).freeze,
      domain: "vcard:Group".freeze,
      label: "member".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasName,
      label: "hasName".freeze,
      range: "vcard:Name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasNickname,
      label: "has nickname".freeze,
      range: "vcard:Nickname".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasNote,
      label: "hasNote".freeze,
      range: "vcard:Note".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasOrganizationName,
      label: "has organization name".freeze,
      range: "vcard:OrganizationName".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasOrganizationalUnitName,
      label: "has organizational unit name".freeze,
      range: "vcard:OrganizationUnitName".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPhoto,
      label: "has photo".freeze,
      range: "vcard:Photo".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRelated,
      label: "has related".freeze,
      range: "vcard:Related".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSound,
      label: "has sound".freeze,
      range: "vcard:Sound".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTelephone,
      label: "has telephone".freeze,
      range: "vcard:Telephone".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTimeZone,
      label: "has time zone".freeze,
      range: "vcard:TimeZone".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTitle,
      label: "has title".freeze,
      range: "vcard:Title".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasURL,
      label: "has URL".freeze,
      range: "vcard:URL".freeze,
      type: "owl:ObjectProperty".freeze
    property :honorificPrefix,
      comment: %(Called Honorific Prefix in vCard).freeze,
      domain: "vcard:Name".freeze,
      label: "honorific prefix".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :honorificSuffix,
      domain: "vcard:Name".freeze,
      label: "honorific suffix".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :instantMessage,
      domain: "vcard:InstantMessage".freeze,
      label: "instant message".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :key,
      domain: "vcard:Key".freeze,
      label: "key".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :language,
      comment: %(Use 2 char language code from RFC5646).freeze,
      label: "has language".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :locality,
      domain: "vcard:Address".freeze,
      label: "locality".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :logo,
      domain: "vcard:Logo".freeze,
      label: "logo".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :nickName,
      domain: "vcard:Nickname".freeze,
      label: "nickName".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :note,
      domain: "vcard:Note".freeze,
      label: "note".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :organizationName,
      domain: "vcard:OrganizationName".freeze,
      label: "organization name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :organizationalUnitName,
      domain: "vcard:OrganizationUnitName".freeze,
      label: "organizational unit name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :photo,
      domain: "vcard:Photo".freeze,
      label: "photo".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :postalCode,
      domain: "vcard:Address".freeze,
      label: "postal code".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :productId,
      label: "product ID".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :region,
      domain: "vcard:Address".freeze,
      label: "region".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :related,
      domain: "vcard:Related".freeze,
      label: "related".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :revision,
      label: "revision".freeze,
      range: "xsd:dateTime".freeze,
      type: "owl:DatatypeProperty".freeze
    property :role,
      domain: "vcard:Role".freeze,
      label: "role".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :sortAs,
      label: "sort as".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :sound,
      domain: "vcard:Sound".freeze,
      label: "sound".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :source,
      label: "source".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :streetAddress,
      domain: "vcard:Address".freeze,
      label: "street address".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :telephone,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#hiddenFromDisplayBelowRoleLevelAnnot" => %(http://vitro.mannlib.cornell.edu/ns/vitro/role#dbAdmin).freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#hiddenFromPublishBelowRoleLevelAnnot" => %(http://vitro.mannlib.cornell.edu/ns/vitro/role#dbAdmin).freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#prohibitedFromUpdateBelowRoleLevelAnnot" => %(http://vitro.mannlib.cornell.edu/ns/vitro/role#dbAdmin).freeze,
      label: "Telephone".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :timeZone,
      domain: "vcard:TimeZone".freeze,
      label: "timezone".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :title,
      domain: "vcard:Title".freeze,
      label: "title".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :uid,
      comment: %(To specify a value that represents a globally unique identifier corresponding to the entity associated with the vCard).freeze,
      label: "uid".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :url,
      label: "URL".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
  end
end
