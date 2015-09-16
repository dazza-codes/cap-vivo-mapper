# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://vivoweb.org/files/vivo-isf-public-1.6.owl
require 'rdf'
module RDF
  class VIVO < RDF::StrictVocabulary("http://vivoweb.org/ontology/core#")

    # Class definitions
    term :Abstract,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An abstract that is published as a standalone document or in a journal of abstracts).freeze,
      label: "Abstract".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :AcademicDegree,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(B.A. Bachelor of Arts).freeze, %(This list may have multiple abbreviations for some degrees.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An academic degree at any level, both as reported by individuals for employment and as offered by academic degree programs.).freeze,
      label: "Academic Degree".freeze,
      subClassOf: "skos:Concept".freeze,
      type: "owl:Class".freeze
    term :AcademicDepartment,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Endodontics \(department within a College of Dentistry\); English \(department within a College of Liberal Arts\)).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A distinct, usually specialized educational unit within an educational organization.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Academic Department".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Department".freeze,
      type: "owl:Class".freeze
    term :AcademicTerm,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An explicit individual academic term, quarter, or semester rather than the generic fall, spring or summer semester.).freeze,
      label: "Academic Term".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#DateTimeInterval".freeze,
      type: "owl:Class".freeze
    term :AcademicYear,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An explicit individual period considered by an academic institution to be its primary academic cycle.).freeze,
      label: "Academic Year".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#DateTimeInterval".freeze,
      type: "owl:Class".freeze
    term :AdministratorRole,
      label: "Administrator Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :AdviseeRole,
      label: "Advisee Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :AdvisingProcess,
      label: "Advising Process".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :AdvisingRelationship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A dual relationship of one person being advised or mentored by another person, typically including start and end dates).freeze,
      label: "Advising Relationship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :AdvisorRole,
      label: "Advisor Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :Association,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Special Libraries Association; Association for Computing Machinery\(ACM\); American Medical Informatics Association\(AMIA\)).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A formal organization of people or groups of people around a subject or practice.).freeze, %(A group of persons or organizations organized for a common purpose.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Association".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :AttendeeRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of attending an Event or EventSeries).freeze,
      label: "Attendee Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :AttendingProcess,
      label: "Attending Process".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :Authorship,
      comment: %().freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Currently any abstract name is given to members of this class. This could change in the future.).freeze, %(Authorship of journal articles, books and other original works is a means by which academics communicate the results of their scholarly work, establish priority for their discoveries, and build their reputation among their peers.
This class allows for linking an author to a publication while indicating information about that author's authorship.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Contains the authors name, their rank in the publication, and whether or not they are a corresponding author on the publication.).freeze,
      label: "Authorship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :Award,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Wiley Prize in Biomedical Sciences).freeze, %(An Award or Honor).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An Award or Honor).freeze,
      label: "Award or Honor".freeze,
      subClassOf: "skos:Concept".freeze,
      type: "owl:Class".freeze
    term :AwardReceipt,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(The award bestowed may be represented with the Award class.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The bestowal of an award, honor, or distinction to a person or person's at a particular time.  ).freeze,
      label: "Award or Honor Receipt".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :AwardedDegree,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The awarding of a degree by an agent to another agent. It is mostly for academic degrees.).freeze,
      label: "Awarded Degree".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :Blog,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Library of Congress Blog).freeze, %(Blog is short for weblog. ).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Regularly updated online journal or newsletter by one or more writers, called bloggers, containing articles and commentary of interest to the blogger).freeze,
      label: "Blog".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Website".freeze,
      type: "owl:Class".freeze
    term :BlogPosting,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A specific blog posting).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An online article or commentary appearing on a blog).freeze,
      label: "Blog Posting".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Article".freeze,
      type: "owl:Class".freeze
    term :Building,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Martha Van Rensselaer Hall \(VR\); Caldwell Hall \(CD\); University Auditorium).freeze, %(Enter building name. If the building's name is a number \(as in many governmental organizations such as national laboratories and military bases\), then enter it. Do not confuse with the number that appears in a postal address.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Building that provides a particular service or is used for a particular activity.).freeze,
      label: "Building".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Facility".freeze,
      type: "owl:Class".freeze
    term :Campus,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Cornell Ithaca; Cornell Geneva; Cornell New York City; Cornell Qatar).freeze, %(Definition taken from dictionary.com \(http://dictionary.reference.com/browse/campus\).).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The grounds of a school, college, university, or hospital. Or, a large, usually suburban, landscaped business or industrial site.).freeze,
      label: "Campus".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeographicLocation".freeze,
      type: "owl:Class".freeze
    term :CaseStudy,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A form of qualitative descriptive research that is used to study individuals, a small group of participants, or a group as a whole. Medical usage \(from MeSH\): clinical presentations that may be followed by evaluative studies that eventually lead to a diagnosis. ).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A qualitative descriptive research study of individuals or a group).freeze,
      label: "Case Study".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :Catalog,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Short Definition is the Medical Subject Heading \(MeSH\) definition ).freeze, %(NLM Catalog).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A list of items in a collection; an ordered compilation of item descriptions and sufficient information to afford access to them).freeze,
      label: "Catalog".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :Center,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Alchohol Education Center; Center for Arts and Public Policy; Hearing Research Center).freeze, %(Short Definition take from http://www.thefreedictionary.com/center.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A place where a particular activity or service is concentrated.).freeze, %(An organization where a specified activity is concentrated.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Center".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Certificate,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A document confirming certain characteristics of a person or organization, usually provided by some form of external review, education, or assessment.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A document confirming certain characteristics of a person or organization, usually provided by some form of external review, education, or assessment.).freeze,
      label: "Certificate".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Credential".freeze,
      type: "owl:Class".freeze
    term :Certification,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(see also core:Certificate).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An issued certificate).freeze,
      label: "Certification".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#IssuedCredential".freeze,
      type: "owl:Class".freeze
    term :ClinicalOrganization,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(In the future we may be able to make this a defined class that would not need to be directly asserted, but the consensus seems to be that some organizations "are" clinical and some "are" research organizations and that the distinction is important enough to warrant the additional class and class assertions).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(Any organization that offers significant health services or routinely provides medical care to patients.).freeze, %(Any organization with a significant clinical function as a matter of course and not just through occasional clinical roles).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Clinical Organization".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :ClinicalRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of observing or treating patients).freeze,
      label: "Clinical Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :CoPrincipalInvestigatorRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Role of co-principal investigator of an Agreement \(for example, a grant\), who devotes a specified percentage of time and is considered key personnel.).freeze,
      label: "Co-Principal Investigator Role".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#InvestigatorRole".freeze,
      type: "owl:Class".freeze
    term :College,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(College of Arts & Sciences; Ivy Tech Community College).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A primary academic unit within a University or a free-standing higher education organization without graduate degree programs.).freeze, %(A primary academic unit within a University or a free-standing higher education organization without graduate degree programs).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "College".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Committee,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Curriculum Steering Committee; PhD Advisory Committee).freeze, %(There could be many subclasses such as thesis committee or tenure committee, but these may typically be differentiated via the moniker unless distinct properties become important.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A group of people organized for a specific purpose \(e.g., a reporting or advisory role\), often with a charge and for a specific duration).freeze, %(A group of people organized for a specific purpose, whose members are often selected from a larger group to serve for designated periods of time.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Committee".freeze,
      subClassOf: "foaf:Group".freeze,
      type: "owl:Class".freeze
    term :Company,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(from Wikipedia: "A company is a form of business organization. It is an association or collection of individual real persons and/or other companies ... This collection, group or association of persons can be made to exist in law and then a company is itself considered a "legal person". The name company arose because, at least originally, it represented or was owned by more than one real or legal person.").freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A legally-recognized business organization).freeze, %(A legally-recognized business organization.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Company".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Competition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Not the same as an award or distinction.).freeze, %(Intel Talent Search; poetry contest).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An occasion on which a winner is selected from among two or more contestants.).freeze,
      label: "Competition".freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze
    term :ConferencePaper,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A paper presented at a conference; optionally collected into a Proceedings or a special Journal issue).freeze,
      label: "Conference Paper".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Article".freeze,
      type: "owl:Class".freeze
    term :ConferencePoster,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The digital file \(or physical equivalent\), if available after the conference, vs. the act of attending/presenting: use ConferencePresentation for information about date/time/location/name of the event where the poster was presented).freeze,
      label: "Conference Poster".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :ConferenceSeries,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(For individual, separate conferences, use conference instead.  core:ConferenceSeries and core:SeminarSeries are very similar.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An organized series of a meeting for consultation or discussion.).freeze,
      label: "Conference Series".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#EventSeries".freeze,
      type: "owl:Class".freeze
    term :Consortium,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Committee on Institutional Cooperation \(CIC\); The Five Colleges of Ohio).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A group  of independent organizations working together toward a common goal, under an expressed agreement.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Consortium".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Continent,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Short Definition take from http://en.wiktionary.org/wiki/continent.).freeze, %(The seven commonly recognized continents are Africa; Antarctica; Asia; Australia; Europe; North America; South America).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A large contiguous landmass  that is at least partially surrounded by water, together with any islands on its continental shelf.).freeze,
      label: "Continent".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeographicRegion".freeze,
      type: "owl:Class".freeze
    term :Contract,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An agreement involving specific deliverables and payment).freeze,
      label: "Contract".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :CoreLaboratory,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A lab providing services such as training, protocols, or access to instruments or software).freeze,
      label: "Core Laboratory".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#ServiceProvidingLaboratory".freeze,
      type: "owl:Class".freeze
    term :Country,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Afghanistan; Antigua and Barbuda; Cameroon; Iceland; Jamaica; Nigeria; United States of America).freeze, %(Source of the Short Definition: http://www.thefreedictionary.com/country.  This is also the same as geopolitical.owl:self_governing.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An area of land distinguished by its political autonomy. Politically independent territories.).freeze,
      label: "Country".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeopoliticalEntity".freeze,
      type: "owl:Class".freeze
    term :County,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Short Definition modified from the one found here: http://www.thefreedictionary.com/county.).freeze, %(Alachua; Baker; Bradford; Kenora; Ottawa; Waterloo).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The largest administrative division of most states or provinces.).freeze,
      label: "County".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeopoliticalEntity".freeze,
      type: "owl:Class".freeze
    term :Course,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A course as taught in one time period \(such as a semester; although note that a course could consist of only one meeting \(teaching session\)\) by one or more instructors, normally but not always for credit. Does not represent either each meeting of the course or the course offering such as Biology 101 taught every semester from 1980 to 2010).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A course as taught in one time period by one or more instructors, normally but not always for credit. Does not represent either each meeting of the course or the course offering such as Biology 101 taught every semester from 1980 to 2010).freeze,
      label: "Course".freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze
    term :Credential,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(An attestation of qualification, competence, or authority issued to an individual by a third party with a relevant or  de facto authority or assumed competence to do so.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An attestation of qualification, competence, or authority issued to an individual by a third party with a relevant or  de facto authority or assumed competence to do so.).freeze,
      label: "Credential".freeze,
      subClassOf: "skos:Concept".freeze,
      type: "owl:Class".freeze
    term :Database,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(PubMed).freeze, %(Short Definition is the Medical Subject Heading \(MeSH\) definition).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A structured file of information or a set of logically related data stored and retrieved using computer-based means).freeze,
      label: "Database".freeze,
      subClassOf: "http://purl.org/ontology/bibo/CollectedDocument".freeze,
      type: "owl:Class".freeze
    term :Dataset,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(US Patent Data; US Job Data).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A named collection of data, usually containing only one type of data).freeze,
      label: "Dataset".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :DateTimeInterval,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(a specific period or duration, defined by \(optional\) start and end date/times.).freeze,
      label: "Date/Time Interval".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000038".freeze,
      type: "owl:Class".freeze
    term :DateTimeValue,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A date and/or time).freeze,
      label: "Date/Time Value".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000148".freeze,
      type: "owl:Class".freeze
    term :DateTimeValuePrecision,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Indicates the precision of the value of a DateTimeValue instance.).freeze,
      label: "Date/Time Value Precision".freeze,
      subClassOf: "skos:Concept".freeze,
      type: "owl:Class".freeze
    term :Department,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Definition modified from the definition here: http://dictionary.reference.com/browse/department. It is difficult to tell the difference between and department and a division.).freeze, %(Legal \(department within a company\); Use for any non-academic department).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A unit within a larger organization that addresses a specific subject or area of activity.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Department".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Division,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Cardiovascular Medicine \(division within medicine\)).freeze, %(Definition modified from http://www.thefreedictionary.com/division.  It is difficult to tell the difference between a division and a department.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A major unit or section within a larger organization.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Division".freeze,
      subClassOf: ["foaf:Organization".freeze, "http://vivoweb.org/ontology/core#ExtensionUnit".freeze],
      type: "owl:Class".freeze
    term :EditorRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(An ongoing editorial responsibility for a bibo:Collection, such as a Journal or Series).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An ongoing editorial responsibility for a bibo:Collection, such as a Journal or Series).freeze,
      label: "Editor Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :EditorialArticle,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An article of opinion, typically published in a newspaper. For academics, most commonly Op Ed pieces).freeze,
      label: "Editorial Article".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Article".freeze,
      type: "owl:Class".freeze
    term :Editorship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A relationship that represents the recognition of an agent as an editor.).freeze,
      label: "Editorship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :EducationalProcess,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Currently any abstract name is given to individuals of this class. This could change in the future.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Represents educational training that has been received.).freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(This connects person to their academic degree through this educational training, but can also be used when the training does not result in a degree.).freeze,
      label: "Educational Process".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :EmeritusFaculty,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A retired faculty member who has retained their rank, title and privileges.).freeze,
      label: "Faculty Member Emeritus".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :EmeritusLibrarian,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A retired librarian who has retained their rank, title and privileges.).freeze,
      label: "Librarian Emeritus".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :EmeritusProfessor,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A retired professor who has retained their rank, title and privileges.).freeze,
      label: "Professor Emeritus".freeze,
      subClassOf: ["http://vivoweb.org/ontology/core#EmeritusFaculty".freeze, "foaf:Person".freeze],
      type: "owl:Class".freeze
    term :Equipment,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(server; Bruker Vector-33 FT-IR).freeze, %(A network server is one example. Medical schools and research laboratories can list professional equipment, such as microscopes.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A physical object provided for specific purpose, task or occupation. ).freeze,
      label: "Equipment".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000040".freeze,
      type: "owl:Class".freeze
    term :EventSeries,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(A generic class which may include a conference series, a course section, a seminar series, or a workshop series. When possible, use one of these more specific classes.).freeze, %(Only use if no specific subclasses of core:EventSeries desribe the activity.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Two or more events that occur at different times and are connected to each other.).freeze,
      label: "Event Series".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :Exhibit,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The showing of an object or a collection of objects, in an organized manner.).freeze,
      label: "Exhibit".freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze
    term :ExtensionUnit,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Alachua County Extension Office).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A unit devoted primarily to extension activities, whether for outreach or research).freeze, %(A unit devoted primarily to extension activities, whether for outreach or research.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Extension Unit".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :F1000Link,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(F1000 is a place where faculty go to critique papers published in PubMed. Any given record in F1000 might have anywhere from one to dozens of reviews.).freeze,
      label: "F1000 Link".freeze,
      subClassOf: "vcard:URL".freeze,
      type: "owl:Class".freeze
    term :Facility,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Use subclasses of core:Facility subclasses instead of this class if possible).freeze, %(Distinct from the organization that runs it; e.g., a laboratory may be an organization but may be run by another organization and only consist of facilities housing equipment or services. Can be a building or place that provides a particular service or is used for a particular activity. Use the specific Building or Room whenever possible. Short definition from http://dictionary.reference.com/browse/facility.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Something designed, built, installed, etc., to serve a specific function or activity affording a convenience or service.).freeze,
      label: "Facility".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000029".freeze,
      type: "owl:Class".freeze
    term :FacultyAdministrativePosition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Associate Dean).freeze, %(That is a position held by an academic faculty member who works for administration.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An academic administrative position \(associate dean, etc.\) as distinct from a professional administrative position \(non-academic\)).freeze,
      label: "Faculty Administrative Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Position".freeze,
      type: "owl:Class".freeze
    term :FacultyMember,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person with at least one academic appointment to a specific faculty of a university or institution of higher learning.).freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(Definition from here: http://research.carleton.ca/htr/defs.php.).freeze,
      label: "Faculty Member".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :FacultyMentoringRelationship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An advisory relationship in which one faculty member mentors another faculty member.).freeze,
      label: "Faculty Mentoring Relationship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#AdvisingRelationship".freeze,
      type: "owl:Class".freeze
    term :FacultyPosition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Professor, associate professor and assistant professor are common positions for academic faculty.).freeze, %(Professor; Associate Professor; Assistant Professor).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Academic position in a university or institution).freeze,
      label: "Faculty Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Position".freeze,
      type: "owl:Class".freeze
    term :Foundation,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(The Ford Foundation).freeze, %(Definition take from: http://dictionary.reference.com/browse/foundation.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An institution founded with an endowment to support educational, research, artistic or other charitable activities.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Foundation".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :FundingOrganization,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(National Institute of Health \(NIH\)).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(A defined class of organizations that fund Grants).freeze, %(An organization that provides financial support to individuals or organizations to carry out specified activities.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Funding Organization".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :GeographicLocation,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Use subclasses of core:Geographic Location subclasses instead of this class if possible.).freeze, %(Removed the word "stable" because disputed territories from geopolitical.owl are included. This could imply that the geographic coordinates could change. I've also copied this definition to core:Geographic Location.  I think core:Geographic Location and core:Geographic Region are both the same and only one is needed. There is also geopolitical.owl:geographical_region which further causes confusion.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A location having coordinates in geographic space.).freeze,
      label: "Geographic Location".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Location".freeze,
      type: "owl:Class".freeze
    term :GeographicRegion,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Removed the word "stable" because disputed territories from geopolitical.owl are included. This could imply that the geographic coordinates could change. This definition was originally in core:Geographic Location.  I simply copied the definition from there.  I think core:Geographic Location and core:Geographic Region are both the same and only one is needed. There is also geopolitical.owl:geographical_region which further causes confusion.).freeze, %(Use subclasses of core:Geographic Region subclasses instead of this class if possible.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A location having coordinates in geographic space.).freeze,
      label: "Geographic Region".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeographicLocation".freeze,
      type: "owl:Class".freeze
    term :GeopoliticalEntity,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Short definition obtained here: http://en.wiktionary.org/wiki/geopolitical_entity.).freeze, %(Use subclasses of core:GeopoliticalEntity subclasses instead of this class if possible.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A geographical area which is associated with some sort of political  structure.).freeze,
      label: "Geopolitical Entity".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeographicRegion".freeze,
      type: "owl:Class".freeze
    term :GovernmentAgency,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(United States Library of Congress).freeze, %(Definition take from: http://en.wikipedia.org/wiki/Government_agency.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A unit of government responsible for oversight and regulation of certain activities or the administration and provision of specific services.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Government Agency".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :GraduateAdvisingRelationship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An advisory relationship in which a professor advises a graduate student.).freeze,
      label: "Graduate Advising Relationship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#AdvisingRelationship".freeze,
      type: "owl:Class".freeze
    term :GraduateStudent,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person who has already received a bachelor's degree and is working toward a Master's or Doctoral degree.).freeze,
      label: "Graduate Student".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Student".freeze,
      type: "owl:Class".freeze
    term :Grant,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(An intramural or extramural award to support scholarly work, such as UF09179 \(VIVO\)).freeze, %(Short definition is from the Glossary of NIH Terms.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Financial assistance mechanism providing money, property, or both to an eligible entity to carry out an approved project or activity).freeze,
      label: "Grant".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :Hospital,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Shands at the University of Florida).freeze, %(Definition take from: http://dictionary.reference.com/browse/hospital.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An institution that provides medical, surgical, psychiatric or nursing care.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Hospital".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Institute,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Institute for Fundamental Theory).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(An organization founded to pursue or promote certain research, educational or public policy interests or activities.).freeze, %(An Institute normally has a research focus but may also fulfill instructional or outreach roles).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Institute".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Internship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Typically a student or a recent graduate undergoing supervised practical training.).freeze,
      label: "Internship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#EducationalProcess".freeze,
      type: "owl:Class".freeze
    term :InvestigatorRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role in an Agreement \(for example, a grant\) as a named investigator or key personnel.).freeze,
      label: "Investigator Role".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#ResearcherRole".freeze,
      type: "owl:Class".freeze
    term :InvitedTalk,
      label: "Invited Talk".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Presentation".freeze,
      type: "owl:Class".freeze
    term :IssuedCredential,
      label: "Issued Credential".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :Laboratory,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(An organizational unit \(as opposed to the physical facility\) that performs research, provides services, or processes materials).freeze, %(An organization unit that facilitates or conduits observation, testing, experimentation, or research in a field of study or practice.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Laboratory".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :LeaderRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A broad-ranging leader concept, from leading a small temporary committee to head of a large international organization.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A leadership role).freeze,
      label: "Leader Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :Librarian,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person working in a position of librarian or information professional, or academic or technical expert in support of providing information services or materials.).freeze,
      label: "Librarian".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :LibrarianPosition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(It is the common position in libraries.).freeze, %(Librarian; Library Systems Analyst; Music Bibliographer).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A position held  by library and information science professionals, or academic or technical experts, in support of providing information services or materials).freeze,
      label: "Librarian Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Position".freeze,
      type: "owl:Class".freeze
    term :Library,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Used information from this definition: http://dictionary.reference.com/browse/library.).freeze, %(Marston Science Library).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An organization maintaining one or more collections of physical and/or electronic information resources for access or lending.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Library".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :License,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Licenses are usually issued in order to regulate some activity that is deemed to be dangerous or a threat to the person or the public or which involves a high level of specialized skill.  See also core:Licensure.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Official or legal permission to do something).freeze,
      label: "License".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Credential".freeze,
      type: "owl:Class".freeze
    term :Licensure,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A granted license, which gives a 'permission to practice.' Such licenses are usually issued in order to regulate some activity that is deemed to be dangerous or a threat to the person or the public or which involves a high level of specialized skill.  See also core:License.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A granted license, which gives a 'permission to practice.').freeze,
      label: "Licensure".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#IssuedCredential".freeze,
      type: "owl:Class".freeze
    term :Location,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Use subclasses of core:Location when classsifying items.).freeze, %(It's anticipated that the subclasses will be used when classifying items. And, all locations can be viewable via this class.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Top level of all location classes.).freeze,
      label: "Location".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000006".freeze,
      type: "owl:Class".freeze
    term :MedicalResidency,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Residency is a stage of graduate medical training. ).freeze,
      label: "Medical Residency".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#EducationalProcess".freeze,
      type: "owl:Class".freeze
    term :Meeting,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A gathering of people for a defined purpose, not necessarily public or announced).freeze,
      label: "Meeting".freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze
    term :MemberRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of being a member in a Process or an Organization).freeze,
      label: "Member Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :Museum,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Definition was take from here:  http://dictionary.reference.com/browse/museum).freeze, %(The Getty Museum).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An organization devoted to the acquisition, conservation, study, exhibition, and educational interpretation of objects having scientific, historical, cultural or artistic value.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Museum".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :NewsRelease,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A short written piece focused on an event or announcement of note, having a defined publication time and of less enduring interest than a news feature.).freeze,
      label: "News Release".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :Newsletter,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(The Ornithological Newsletter).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Usually issued periodically, prepared by or for a group or institution to present information to a specific audience, often also made available to the press and public).freeze,
      label: "Newsletter".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Periodical".freeze,
      type: "owl:Class".freeze
    term :NonAcademic,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person holding a position that is not considered to be an academic appointment.).freeze,
      label: "Non-Academic".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :NonAcademicPosition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Staff, support, and other non-academic positions.).freeze, %(Accounting & Research Services Assistant; Director of Information Technology).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A position classified as professional, staff, support, or any other non-academic role).freeze,
      label: "Non-Academic Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Position".freeze,
      type: "owl:Class".freeze
    term :NonFacultyAcademic,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person not considered a faculty member but holding an academic appointment.).freeze,
      label: "Non-Faculty Academic".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :NonFacultyAcademicPosition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Researcher; Academic Extension Associate; Postdoctoral Associate).freeze, %(Those positions are held by people who do academic work but do not have faculty positions in universities or institutes.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A position involving academic work but without faculty status).freeze,
      label: "Non-Faculty Academic Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Position".freeze,
      type: "owl:Class".freeze
    term :OrganizerRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of organizing).freeze,
      label: "Organizer Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :OrganizingProcess,
      label: "Organizing Process".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :OutreachProviderRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Communicating Astronomy to the Public).freeze, %(The example is one outreach role required by US space agency NASA, which is related with one project in NASA. Name of the outreach role should be put here.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An outreach or community service role directed outside a person's primary profession and institution).freeze,
      label: "Outreach Provider Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :PeerReviewerRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(is a generic term for a process of self-regulation by a profession or a process of evaluation involving qualified individuals within the relevant field. Peer review methods are employed to maintain standards, improve performance and provide credibility. In academia  the term is often used to denote a prepublication review of academic papers; reviewing an academic paper is often called refereeing.
Contents
[hide]).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of peer reviewing).freeze,
      label: "Peer Reviewer Role".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#ReviewerRole".freeze,
      type: "owl:Class".freeze
    term :PopulatedPlace,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Either city or town - a thickly populated area having fixed boundaries and certain local powers of government.).freeze,
      label: "Populated Place".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeopoliticalEntity".freeze,
      type: "owl:Class".freeze
    term :Position,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Director of Admissions and Placement; Associate University Librarian).freeze, %(An employment activity, whether compensated or not. Short definition comes from http://en.wikipedia.org/wiki/Position, and has been modified.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Particular position in an organization, commonly identified by job title, and normally associated with a job description that details the tasks and responsibilities that go with the position.).freeze,
      label: "Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Relationship".freeze,
      type: "owl:Class".freeze
    term :Postdoc,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A Person holding an academic employment appointment focused on research rather than teaching; temporary \(or for some defined term\)).freeze,
      label: "Postdoc".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#NonFacultyAcademic".freeze,
      type: "owl:Class".freeze
    term :PostdocOrFellowAdvisingRelationship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An advisory relationship in which the advisee is a Postdoc or Fellow.).freeze,
      label: "Postdoc or Fellow Advising Relationship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#AdvisingRelationship".freeze,
      type: "owl:Class".freeze
    term :PostdocPosition,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A postdoctoral training appointment \(job\)).freeze,
      label: "Postdoctoral Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#NonFacultyAcademicPosition".freeze,
      type: "owl:Class".freeze
    term :PostdoctoralTraining,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Postdoctoral research is academic or scholarly research conducted by a person who has completed his or her doctoral studies, normally within the following five years. It is intended to further deepen expertise in a specialist subject.).freeze,
      label: "Postdoctoral Training".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#EducationalProcess".freeze,
      type: "owl:Class".freeze
    term :Presentation,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Encompasses talk, speech, lecture, slide lecture, conference presentation).freeze,
      label: "Presentation".freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze
    term :PresenterRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Are we assuming that a PresenterRole is in a Presentation?  Or could you have a PresenterRole in, say, a committee?).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of presenting information).freeze,
      label: "Presenter Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :PresentingProcess,
      label: "Presenting Process".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :PrimaryPosition,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A position designated as primary by the organization or group where it is held. This designation may be applied to zero or more of an agent's positions and may be asserted in conjunction with other subclasses of position.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A position designated as primary by the organization where it is held.).freeze,
      label: "Primary Position".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Position".freeze,
      type: "owl:Class".freeze
    term :PrincipalInvestigatorRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Role of a person to direct a project or activity being supported by an Agreement \(for example, a grant\), and who is accountable to the grantee for the proper conduct of the project or activity. Also known as Program Director or Project Director.).freeze,
      label: "Principal Investigator Role".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#InvestigatorRole".freeze,
      type: "owl:Class".freeze
    term :PrivateCompany,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Publix Super Markets; Ernst & Young; PricewaterhouseCoopers).freeze, %(Definition obtained here: http://answers.ask.com/Business/Finance/what_is_a_private_company.  Examples of private companies found here: http://www.forbes.com/2008/11/03/largest-private-companies-biz-privates08-cx_sr_1103private_land.html).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A private company is one that is privately-owned, and thus, is not publicly-traded in the stock market. Members of the general public cannot purchase stock in a private company unless that company chooses to go public and become a public company.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Private Company".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Company".freeze,
      type: "owl:Class".freeze
    term :Program,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A Cornell graduate field \(http://vivo.cornell.edu/index.jsp?home=65535&collection=820\)).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An ongoing academic initiative not formalized with department or division status.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Program".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Project,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(An endeavor, frequently collaborative, that occurs over a finite period of time and is intended to achieve a particular aim.
).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An endeavor, frequently collaborative, that occurs over a finite period of time and is intended to achieve a particular aim.).freeze,
      label: "Project".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000015".freeze,
      type: "owl:Class".freeze
    term :Publisher,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Elsevier; Harper & Row; Indiana University Press).freeze, %(Definition found here: http://dictionary.reference.com/browse/publisher).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person or company whose business is the publishing of books, periodicals, engravings, computer software, etc.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Publisher".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Relationship,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(functions as an n-ary predicate).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(a reified relationship).freeze,
      label: "Relationship".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000020".freeze,
      type: "owl:Class".freeze
    term :ResearchOrganization,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Any organization \(likely also asserted as another class of Organization\) with a primary, ongoing research function, not just through occasional roles).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Research Organization".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :ResearchProposal,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A proposal for a research grant that has been submitted but not approved; does not represent an existing activity).freeze,
      label: "Research Proposal".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :ResearcherRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Examples of research can be seen at: http://www.ufl.edu/research/products/index.html.  Note these may have been funded, but the research doesn't have to be funded.  Also, the research may be linked to an Agreement \(for example, a Grant\), but does not need to be.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of conducting funded or unfunded research,  sometimes linked to an Agreement.).freeze,
      label: "Researcher Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :Review,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An article reviewing one or more other information resources \(a book, one or more other articles, movies, etc\)).freeze,
      label: "Review".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Article".freeze,
      type: "owl:Class".freeze
    term :ReviewerRole,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(A role that encompasses both ongoing reviewer responsibility for a bibo:Collection, such as a Journal or Series, and also a review performed for a bibo:Document, such as a book, academic article or conference paper.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role that encompasses both ongoing reviewer responsibility for a bibo:Collection, such as a Journal or Series, and also a review performed for a bibo:Document, such as a book, academic article or conference paper.).freeze,
      label: "Reviewer Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :Room,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Enter room number of name.).freeze, %(100 Caldwell Hall; 114 Martha Van Rensselaer \(Rushmore Conference Room\)).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Room that provides a particular service or is used for a particular activity.).freeze,
      label: "Room".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Facility".freeze,
      type: "owl:Class".freeze
    term :School,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Definition take from here: http://dictionary.reference.com/browse/school.).freeze, %(School of Architecture; School of Music).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An institution for instruction in a particular skill or field.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "School".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Score,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Written musical composition for voice or instruments or both).freeze,
      label: "Score".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :Screenplay,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Written script for a film production, including dialogue and descriptions of gestures, actions, shooting directions).freeze,
      label: "Screenplay".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :SeminarSeries,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Applied Microeconomics Seminars; Future of Rural New York Seminar Series).freeze, %(For individual seminars, use seminar instead.  core:ConferenceSeries and core:SeminarSeries are very similar.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An organized series of a meeting for an exchange of ideas, typically put on by a department or center.).freeze,
      label: "Seminar Series".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#EventSeries".freeze,
      type: "owl:Class".freeze
    term :ServiceProvidingLaboratory,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Ideally a defined class -- a Laboratory the provides some Service via the property).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A laboratory that provides services).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Service Providing Lab".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Laboratory".freeze,
      type: "owl:Class".freeze
    term :Speech,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Text of a speech written in preparation for delivery of the speech.).freeze,
      label: "Speech".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :StateOrProvince,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Minnesota; Michigan; Indiana; New York; Quebec; Manitoba; Ontario).freeze, %(Source of the Short Definition: http://www.thefreedictionary.com/state.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(One of a number of areas or communities having their own governments and forming a federation under a sovereign government, as in the US.).freeze,
      label: "State or Province".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeopoliticalEntity".freeze,
      type: "owl:Class".freeze
    term :Student,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Use only if no specific subclasses of core:Student describe the person.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person who is enrolled in an educational institution.).freeze,
      label: "Student".freeze,
      subClassOf: "foaf:Person".freeze,
      type: "owl:Class".freeze
    term :StudentOrganization,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Definition take from here: http://en.wikipedia.org/wiki/Student_society).freeze, %(Dancin' Gators).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A student organization is an organization, operated by students at a university, whose membership normally consists only of students.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Student Organization".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :SubnationalRegion,
      comment: %(For example, the Midwest, northeast U.S.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Short definition was partially taken from http://en.wikipedia.org/wiki/Subnational_entity.).freeze, %(Boroughs; townships; districts; the Midwest).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Smaller administrative division into which a country may be divided.).freeze,
      label: "Subnational Region".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#GeographicRegion".freeze,
      type: "owl:Class".freeze
    term :TeacherRole,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A role of serving as an educator).freeze,
      label: "Teacher Role".freeze,
      subClassOf: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:Class".freeze
    term :Team,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(VIVO Outreach Team; VIVO Ontology Team).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => [%(An informal organization brought together for the purposes of a project or event).freeze, %(A group of people working together.).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "Team".freeze,
      subClassOf: "foaf:Group".freeze,
      type: "owl:Class".freeze
    term :Translation,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(The result of rendering a work from one language to another).freeze,
      label: "Translation".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :UndergraduateAdvisingRelationship,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An advisory relationship in which a professor advises an undergraduate student.).freeze,
      label: "Undergraduate Advising Relationship".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#AdvisingRelationship".freeze,
      type: "owl:Class".freeze
    term :UndergraduateStudent,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A person registered in an undergraduate program leading to a bachelor's degree or an undergraduate diploma or certificate.).freeze,
      label: "Undergraduate Student".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#Student".freeze,
      type: "owl:Class".freeze
    term :University,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(University of Florida; Washington University in St. Louis).freeze, %(Definition taken from: http://en.wikipedia.org/wiki/University).freeze],
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An institution of higher education and research, which grants academic degrees in a variety of subjects, and provides both undergraduate education and postgraduate education.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000412" => %(http://vivoweb.org/ontology/core).freeze,
      label: "University".freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze
    term :Video,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Audiovisual recording in video format).freeze,
      label: "Video".freeze,
      subClassOf: "http://purl.org/ontology/bibo/AudioVisualDocument".freeze,
      type: "owl:Class".freeze
    term :WorkingPaper,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(A document created as a basis for discussion or a very early draft of a formal paper).freeze,
      label: "Working Paper".freeze,
      subClassOf: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:Class".freeze
    term :WorkshopSeries,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Use workshop for individual events.).freeze,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(An organized series of workshop events, whether repetitions of the same workshop or multiple different workshops.).freeze,
      label: "Workshop Series".freeze,
      subClassOf: "http://vivoweb.org/ontology/core#EventSeries".freeze,
      type: "owl:Class".freeze

    # Property definitions
    property :abbreviation,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(A short form for an longer title or name.).freeze, %(B.A.).freeze],
      label: "abbreviation".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :affiliatedOrganization,
      domain: "foaf:Organization".freeze,
      label: "has affiliated organization".freeze,
      range: "foaf:Organization".freeze,
      type: "owl:ObjectProperty".freeze
    property :assignedBy,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Relates a Relationship \(as a predicate or n-ary relation over one or more Thing\) to an Agent that defined or instantiated the predicate instance. ).freeze,
      label: "assigned by".freeze,
      type: "owl:ObjectProperty".freeze
    property :assignee,
      domain: "http://purl.org/ontology/bibo/Patent".freeze,
      label: "assignee".freeze,
      range: "foaf:Agent".freeze,
      type: "owl:ObjectProperty".freeze
    property :assigneeFor,
      domain: "foaf:Agent".freeze,
      label: "assignee for patent".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#assignee).freeze,
      range: "http://purl.org/ontology/bibo/Patent".freeze,
      type: "owl:ObjectProperty".freeze
    property :assigns,
      label: "assigns".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#assignedBy).freeze,
      type: "owl:ObjectProperty".freeze
    property :cclCode,
      domain: "http://purl.org/ontology/bibo/Patent".freeze,
      label: "published US Classification Class/subclass (CCL) code".freeze,
      type: "owl:DatatypeProperty".freeze
    property :contributingRole,
      label: "contributor".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#roleContributesTo).freeze,
      range: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      type: "owl:ObjectProperty".freeze
    property :courseCredits,
      label: "credits".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :dateFiled,
      domain: "http://purl.org/ontology/bibo/Patent".freeze,
      label: "date filed".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#dateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :dateIssued,
      label: "date issued".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#dateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :dateTime,
      domain: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      label: "date/time".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#dateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :dateTimeInterval,
      label: "date/time interval".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeInterval".freeze,
      type: "owl:ObjectProperty".freeze
    property :dateTimePrecision,
      domain: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      label: "date/time precision".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValuePrecision".freeze,
      type: "owl:ObjectProperty".freeze
    property :dateTimeValue,
      label: "date/time value".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :degreeCandidacy,
      domain: "http://vivoweb.org/ontology/core#AdvisingRelationship".freeze,
      label: "degree candidacy".freeze,
      range: "http://vivoweb.org/ontology/core#AcademicDegree".freeze,
      type: "owl:ObjectProperty".freeze
    property :departmentOrSchool,
      domain: "http://vivoweb.org/ontology/core#EducationalProcess".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(Not intended to be an institution name.).freeze,
      label: "department or school name within institution".freeze,
      type: "owl:DatatypeProperty".freeze
    property :description,
      label: "description".freeze,
      type: ["owl:AnnotationProperty".freeze, "owl:DatatypeProperty".freeze]
    property :distributes,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(Public Description for bibo:distributor taken from here:  http://bibotools.googlecode.com/svn/bibo-ontology/trunk/doc/index.html .).freeze,
      label: "distributes".freeze,
      "owl:inverseOf" => %(http://purl.org/ontology/bibo/distributor).freeze,
      type: "owl:ObjectProperty".freeze
    property :distributesFundingFrom,
      domain: "http://vivoweb.org/ontology/core#FundingOrganization".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(For example, National Science Foundation providesFundingThrough Graduate Research Fellowship Program; National Institutes of Health providesFundingThrough National Center for Research Resources. ).freeze,
      label: "distributes funding from".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#providesFundingThrough).freeze,
      range: "http://vivoweb.org/ontology/core#FundingOrganization".freeze,
      type: "owl:ObjectProperty".freeze
    property :eRACommonsId,
      domain: "foaf:Person".freeze,
      label: "eRA Commons ID".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :eligibleFor,
      label: "credential eligibility attained".freeze,
      range: "http://vivoweb.org/ontology/core#Credential".freeze,
      type: "owl:ObjectProperty".freeze
    property :end,
      domain: "http://vivoweb.org/ontology/core#DateTimeInterval".freeze,
      label: "end".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#dateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :entryTerm,
      label: "entry term".freeze,
      type: "owl:DatatypeProperty".freeze
    property :equipmentFor,
      domain: "http://vivoweb.org/ontology/core#Equipment".freeze,
      label: ["equipment for".freeze, "equipment for".freeze],
      range: "foaf:Organization".freeze,
      subPropertyOf: "http://isf/deprecated_op".freeze,
      type: "owl:ObjectProperty".freeze
    property :expirationDate,
      label: "expiration date".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#dateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :facilityFor,
      domain: "http://vivoweb.org/ontology/core#Facility".freeze,
      label: "facilityFor".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#hasFacility).freeze,
      type: "owl:ObjectProperty".freeze
    property :featuredIn,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(This is done through a restriction on the foaf:Person class.).freeze,
      label: "featured in".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#features).freeze,
      range: "http://purl.obolibrary.org/obo/IAO_0000030".freeze,
      type: "owl:ObjectProperty".freeze
    property :features,
      domain: "http://purl.obolibrary.org/obo/IAO_0000030".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(This is done through a restriction on the foaf:Person class.).freeze,
      label: "features".freeze,
      range: "foaf:Agent".freeze,
      type: "owl:ObjectProperty".freeze
    property :freetextKeyword,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(conservation

use one freetextKeyword assertion for each keyword or phrase.).freeze, %(one keyword or phrase per freetextKeyword assertion).freeze],
      label: "keywords".freeze,
      type: "owl:DatatypeProperty".freeze
    property :fundingVehicleFor,
      domain: "http://vivoweb.org/ontology/core#Grant".freeze,
      label: "provides funding for".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#hasFundingVehicle).freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#supports".freeze,
      type: "owl:ObjectProperty".freeze
    property :geographicFocus,
      label: "geographic focus".freeze,
      range: "http://vivoweb.org/ontology/core#GeographicRegion".freeze,
      type: "owl:ObjectProperty".freeze
    property :geographicFocusOf,
      domain: "http://vivoweb.org/ontology/core#GeographicRegion".freeze,
      label: "geographic focus of".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#geographicFocus).freeze,
      type: "owl:ObjectProperty".freeze
    property :governingAuthorityFor,
      domain: "foaf:Organization".freeze,
      label: "governing authority for".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#hasGoverningAuthority).freeze,
      type: "owl:ObjectProperty".freeze
    property :grantDirectCosts,
      domain: "http://vivoweb.org/ontology/core#Grant".freeze,
      label: "direct costs".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :grantSubcontractedThrough,
      domain: "http://vivoweb.org/ontology/core#Grant".freeze,
      label: "subcontracted through".freeze,
      range: "foaf:Organization".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasAssociatedConcept,
      label: "associated concept".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#conceptAssociatedWith).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCollaborator,
      domain: "foaf:Agent".freeze,
      label: "has collaborator".freeze,
      range: "foaf:Agent".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasEquipment,
      domain: "foaf:Organization".freeze,
      label: "has equipment".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#equipmentFor).freeze,
      range: "http://vivoweb.org/ontology/core#Equipment".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasMonetaryAmount,
      label: "has monetary amount".freeze,
      type: "owl:DatatypeProperty".freeze
    property :hasPredecessorOrganization,
      domain: "foaf:Organization".freeze,
      label: "predecessor organization".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#hasSuccessorOrganization).freeze,
      range: "foaf:Organization".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPrerequisite,
      domain: "http://vivoweb.org/ontology/core#Course".freeze,
      label: "has prerequisite".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#prerequisiteFor).freeze,
      range: "http://vivoweb.org/ontology/core#Course".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasProceedings,
      domain: "http://purl.org/ontology/bibo/Conference".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(A possible working example: The conference proceeding of the SPIE was generated from the conference - International Society for Optical Engineering.).freeze,
      label: "proceedings".freeze,
      range: "http://purl.org/ontology/bibo/Proceedings".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPublicationVenue,
      label: "published in".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#publicationVenueFor).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasResearchArea,
      label: "research areas".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#researchAreaOf).freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#hasAssociatedConcept".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSubjectArea,
      label: "has subject area".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#subjectAreaOf).freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#hasAssociatedConcept".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSuccessorOrganization,
      domain: "foaf:Organization".freeze,
      label: "successor organization".freeze,
      range: "foaf:Organization".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTranslation,
      domain: "http://purl.org/ontology/bibo/Document".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Examples shows a book has French language version. Public description source: http://bibotools.googlecode.com/svn/bibo-ontology/trunk/doc/index.html .).freeze,
      label: "has translation".freeze,
      "owl:inverseOf" => %(http://purl.org/ontology/bibo/translationOf).freeze,
      range: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasValue,
      label: "has value".freeze,
      type: "owl:DatatypeProperty".freeze
    property :hideFromDisplay,
      label: "hide from display".freeze,
      range: "xsd:boolean".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :hrJobTitle,
      domain: "http://vivoweb.org/ontology/core#Position".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(Definition http://en.wikipedia.org/wiki/Job_title#Job_title.).freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#exampleAnnot" => %(administrative secretary).freeze,
      label: "HR job title".freeze,
      type: "owl:DatatypeProperty".freeze
    property :iclCode,
      domain: "http://purl.org/ontology/bibo/Patent".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(The International classification\(s\) to which the published application has been assigned.
).freeze,
      label: "International Classification (ICL) code".freeze,
      type: "owl:DatatypeProperty".freeze
    property :identifier,
      label: "identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :informationResourceSupportedBy,
      domain: "http://purl.obolibrary.org/obo/IAO_0000030".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(an information resource \(typically a publication\) supported by \(typically via funding\) an agreement \(such as a grant\)).freeze,
      label: "supported by".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#supportedBy".freeze,
      type: "owl:ObjectProperty".freeze
    property :isCorrespondingAuthor,
      domain: "http://vivoweb.org/ontology/core#Authorship".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#exampleAnnot" => %(True; False).freeze,
      label: "Is this person a corresponding author?".freeze,
      range: "xsd:boolean".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :licenseNumber,
      domain: "http://vivoweb.org/ontology/core#Licensure".freeze,
      label: "license number".freeze,
      type: "owl:DatatypeProperty".freeze
    property :localAwardId,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(core:localAwardId has a domain of core:Grant, and should be public since that's its public identifier for local use by OSP, accounting, department admins, and the PI ).freeze,
      label: "local award ID".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :majorField,
      domain: "http://vivoweb.org/ontology/core#EducationalProcess".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Information Science; Computer Science; Anthropology).freeze,
      label: "major field of degree".freeze,
      type: "owl:DatatypeProperty".freeze
    property :middleName,
      label: "middle name or initial".freeze,
      type: "owl:DatatypeProperty".freeze
    property :nihmsid,
      domain: "http://purl.org/ontology/bibo/Article".freeze,
      label: "NIH Manuscript Submission System ID".freeze,
      subPropertyOf: "http://purl.org/ontology/bibo/identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :offeredBy,
      label: "offered by".freeze,
      type: "owl:ObjectProperty".freeze
    property :offers,
      label: "offers".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#offeredBy).freeze,
      type: "owl:ObjectProperty".freeze
    property :orcidId,
      domain: "foaf:Person".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(This is now an object property where the object value is a resource of the form <http://orcid.org/NNNN-NNNN-NNNN-NNNN>.  This is to support connecting VIVO and ORCID in the linked data web.   Note: a person can have multiple ORCID iDs.).freeze,
      label: "ORCID iD".freeze,
      type: "owl:ObjectProperty".freeze
    property :outreachOverview,
      domain: "foaf:Person".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(Used for a single narrative summary of outreach, typically covering a wide range of activities and time periods; use Outreach Provider Role for information on individual activities).freeze, %(My extension program consists of developing and reporting disease management strategies that are both economically and environmentally sound for fresh market vegetable production. We hope that some of this testing will result in practices adaptable for organic production.).freeze],
      label: "outreach overview".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :overview,
      domain: "foaf:Agent".freeze,
      label: "overview".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :patentNumber,
      domain: "http://purl.org/ontology/bibo/Patent".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(source of definition: http://www.uspto.gov/main/glossary/#p . The following site has patent number formats: http://www.uspto.gov/patents/ebc/kindcodesum.jsp .).freeze,
      label: "patent number".freeze,
      subPropertyOf: "http://purl.org/ontology/bibo/identifier".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :placeOfPublication,
      label: "place of publication".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :pmcid,
      domain: "http://purl.org/ontology/bibo/Article".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(   A PMCID is a unique PubMed Central reference number, which is assigned to each full-text record made available A PMCID is a unique PubMed Central reference number, which is assigned to each full-text record made available in PubMed Central. The PMCID is issued shortly after the PI or author approves the PubMed Central formatted web version of the submission. ).freeze,
      label: "PubMed Central ID".freeze,
      subPropertyOf: "http://purl.org/ontology/bibo/identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :preferredDisplayOrder,
      label: "preferred display order".freeze,
      type: "owl:DatatypeProperty".freeze
    property :prerequisiteFor,
      domain: "http://vivoweb.org/ontology/core#Course".freeze,
      label: "prerequisite for".freeze,
      range: "http://vivoweb.org/ontology/core#Course".freeze,
      type: "owl:ObjectProperty".freeze
    property :proceedingsOf,
      domain: "http://purl.org/ontology/bibo/Proceedings".freeze,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(A possible working example: The conference proceeding of the SPIE was generated from the conference - International Society for Optical Engineering.).freeze,
      label: "proceedings of".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#hasProceedings).freeze,
      range: "http://purl.org/ontology/bibo/Conference".freeze,
      type: "owl:ObjectProperty".freeze
    property :providesFundingThrough,
      domain: "http://vivoweb.org/ontology/core#FundingOrganization".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(For example, National Science Foundation providesFundingThrough Graduate Research Fellowship Program; National Institutes of Health providesFundingThrough National Center for Research Resources. ).freeze,
      label: "provides funding through".freeze,
      range: "http://vivoweb.org/ontology/core#FundingOrganization".freeze,
      type: "owl:ObjectProperty".freeze
    property :publicationVenueFor,
      label: "publication venue for".freeze,
      type: "owl:ObjectProperty".freeze
    property :publisher,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Public Definition source \(http://www.answers.com/topic/publisher\).).freeze,
      label: "publisher".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#publisherOf).freeze,
      range: "foaf:Organization".freeze,
      type: "owl:ObjectProperty".freeze
    property :publisherOf,
      domain: "foaf:Organization".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Public Definition source \(http://www.answers.com/topic/publisher\).).freeze,
      label: "publisher of".freeze,
      range: "http://purl.obolibrary.org/obo/IAO_0000030".freeze,
      type: "owl:ObjectProperty".freeze
    property :rank,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(this number indicates a position in a list).freeze,
      label: "rank".freeze,
      range: "xsd:int".freeze,
      type: "owl:DatatypeProperty".freeze
    property :relatedBy,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Relates a Thing to a Relationship as a Thing that is somehow related to other Thing in the same Relationship instance. A Relationship instnace is a predicate over Thing and is created by an Agent.).freeze,
      label: "related by".freeze,
      type: "owl:ObjectProperty".freeze
    property :relates,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Relates a Relationship instance to the one or more Thing of the Relationship. There is a separate property \(assigned by\) to relate to the Agent that defines the Relationship.).freeze,
      label: "relates".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#relatedBy).freeze,
      type: "owl:ObjectProperty".freeze
    property :reportId,
      domain: "http://purl.org/ontology/bibo/Report".freeze,
      label: "report identifier".freeze,
      subPropertyOf: "http://purl.org/ontology/bibo/identifier".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :reproduces,
      domain: "http://purl.org/ontology/bibo/Document".freeze,
      label: "reproduces".freeze,
      "owl:inverseOf" => %(http://purl.org/ontology/bibo/reproducedIn).freeze,
      range: "http://purl.org/ontology/bibo/Document".freeze,
      subPropertyOf: "http://purl.obolibrary.org/obo/BFO_0000051".freeze,
      type: "owl:ObjectProperty".freeze
    property :researchAreaOf,
      label: "research area of".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#conceptAssociatedWith".freeze,
      type: "owl:ObjectProperty".freeze
    property :researchOverview,
      domain: "foaf:Person".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Used for a single narrative summary of research, typically covering a wide range of activities and time periods; use Researcher Role for information on individual activities).freeze,
      label: "research overview".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :researcherId,
      domain: "foaf:Person".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(RearcherID is a Thomson Reuters project where researchers have a place to manage and share their professional information. It will allow them to solve author identity issues while simultaneously adding dynamic citation metrics and collaboration networks to your personal profile.
Definition source: http://isiwebofknowledge.com/researcherid/).freeze,
      label: "ISI Researcher ID".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :reviewedIn,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(The bibo:reviewOf public description was found here: http://bibotools.googlecode.com/svn/bibo-ontology/trunk/doc/index.html .  As of 26 May 2010, bibo:reviewOf is used with the class Review, but core:reviewIn doesn't seem to be being used.).freeze,
      label: "reviewed in".freeze,
      range: "http://vivoweb.org/ontology/core#Review".freeze,
      type: "owl:ObjectProperty".freeze
    property :roleContributesTo,
      domain: "http://purl.obolibrary.org/obo/BFO_0000023".freeze,
      label: "contributes to".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#contributingRole).freeze,
      type: "owl:ObjectProperty".freeze
    property :scopusId,
      domain: "foaf:Person".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Home page for Scopus: http://www.scopus.com/home.url).freeze,
      label: "Scopus ID".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#identifier".freeze,
      type: "owl:DatatypeProperty".freeze
    property :seatingCapacity,
      domain: "http://vivoweb.org/ontology/core#Room".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => [%(55).freeze, %(definition modified from: source \(http://en.wikipedia.org/wiki/Seating_capacity\).).freeze],
      label: "seating capacity".freeze,
      range: "xsd:int".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :sponsorAwardId,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Has a domain of Grant. There is not a strong reason have this be publically visible, since most users would care more about the name of the sponsoring agency than its identifier, but it does no harm to be public.


See also core:localAwardId.
).freeze,
      label: "sponsor award ID".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#identifier".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :sponsoredBy,
      domain: "http://vivoweb.org/ontology/core#Award".freeze,
      label: "award sponsored by".freeze,
      range: "foaf:Organization".freeze,
      type: "owl:ObjectProperty".freeze
    property :sponsors,
      domain: "foaf:Organization".freeze,
      label: "sponsors award or honor".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#sponsoredBy).freeze,
      range: "http://vivoweb.org/ontology/core#Award".freeze,
      type: "owl:ObjectProperty".freeze
    property :start,
      domain: "http://vivoweb.org/ontology/core#DateTimeInterval".freeze,
      label: "start".freeze,
      range: "http://vivoweb.org/ontology/core#DateTimeValue".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#dateTimeValue".freeze,
      type: "owl:ObjectProperty".freeze
    property :subcontractsGrant,
      domain: "foaf:Organization".freeze,
      label: "subcontracts grant".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#grantSubcontractedThrough).freeze,
      range: "http://vivoweb.org/ontology/core#Grant".freeze,
      type: "owl:ObjectProperty".freeze
    property :subjectAreaOf,
      label: "subject area of".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#conceptAssociatedWith".freeze,
      type: "owl:ObjectProperty".freeze
    property :supplementalInformation,
      label: "supplemental information".freeze,
      type: "owl:DatatypeProperty".freeze
    property :supportedBy,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(general relationship of support).freeze,
      label: "supported by".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#supports).freeze,
      type: "owl:ObjectProperty".freeze
    property :supportedInformationResource,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(an information resource \(typically a publication\) supported by \(typically via funding\) an agreement \(such as a grant\)).freeze,
      label: "supported publications or other works".freeze,
      "owl:inverseOf" => %(http://vivoweb.org/ontology/core#informationResourceSupportedBy).freeze,
      range: "http://purl.obolibrary.org/obo/IAO_0000030".freeze,
      subPropertyOf: "http://vivoweb.org/ontology/core#supports".freeze,
      type: "owl:ObjectProperty".freeze
    property :supports,
      "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#descriptionAnnot" => %(general relationship of support).freeze,
      label: "supports".freeze,
      type: "owl:ObjectProperty".freeze
    property :teachingOverview,
      domain: "foaf:Person".freeze,
      "http://purl.obolibrary.org/obo/IAO_0000112" => %(Used for a single narrative summary of teaching, typically covering a wide range of courses including for credit and non-credit teaching over multiple semesters; the "teaches" property links a person directly with an instance of a Semester Class, typically from an institutional database of record; then use Teacher Role for information about a person's role in non-credit teaching or their specific contribution to individual courses).freeze,
      label: "teaching overview".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :termLabel,
      label: "term label".freeze,
      type: "owl:DatatypeProperty".freeze
    property :termType,
      label: "term type".freeze,
      type: "owl:DatatypeProperty".freeze
    property :totalAwardAmount,
      label: "total award amount".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze]
    property :translatorOf,
      domain: "foaf:Agent".freeze,
      label: "translator of".freeze,
      range: "http://purl.org/ontology/bibo/Document".freeze,
      type: "owl:ObjectProperty".freeze
    property :validIn,
      label: "valid in".freeze,
      range: "http://vivoweb.org/ontology/core#GeographicLocation".freeze,
      type: "owl:ObjectProperty".freeze

    # Extra definitions
    term :conceptAssociatedWith,
      label: "concept for".freeze
    term :contactInformation,
      label: "contact information".freeze
    term :hasFacility,
      label: "has facility".freeze,
      range: "http://vivoweb.org/ontology/core#Facility".freeze
    term :hasFundingVehicle,
      label: "funding provided via".freeze
    term :hasGoverningAuthority,
      label: "governing authority".freeze,
      range: "foaf:Organization".freeze
    term :inPress,
      "http://purl.obolibrary.org/obo/IAO_0000115" => %(Document to be published).freeze,
      "http://vivoweb.org/ontology/core#description" => %(Document to be published).freeze,
      label: "in press".freeze,
      type: ["http://purl.org/ontology/bibo/DocumentStatus".freeze, "owl:NamedIndividual".freeze]
    term :invited,
      label: "invited".freeze,
      type: ["http://purl.org/ontology/bibo/DocumentStatus".freeze, "owl:NamedIndividual".freeze]
    term :submitted,
      label: "submitted".freeze,
      type: ["http://purl.org/ontology/bibo/DocumentStatus".freeze, "owl:NamedIndividual".freeze]
    term :yearMonthDayPrecision,
      label: ["yearMonthDayPrecision".freeze, "year-month-day value".freeze],
      type: ["http://vivoweb.org/ontology/core#DateTimeValuePrecision".freeze, "owl:NamedIndividual".freeze]
    term :yearMonthDayTimePrecision,
      label: ["yearMonthDayTimePrecision".freeze, "year-month-day-time value".freeze],
      type: ["http://vivoweb.org/ontology/core#DateTimeValuePrecision".freeze, "owl:NamedIndividual".freeze]
    term :yearMonthPrecision,
      label: ["yearMonthPrecision".freeze, "year-month value".freeze],
      type: ["http://vivoweb.org/ontology/core#DateTimeValuePrecision".freeze, "owl:NamedIndividual".freeze]
    term :yearPrecision,
      label: ["year value".freeze, "yearPrecision".freeze],
      type: ["http://vivoweb.org/ontology/core#DateTimeValuePrecision".freeze, "owl:NamedIndividual".freeze]
  end
end
