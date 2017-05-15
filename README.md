[![Build Status](https://travis-ci.org/sul-dlss/cap-vivo-mapper.svg?branch=master)](https://travis-ci.org/sul-dlss/cap-vivo-mapper)

# Cap::Vivo::Mapper

This utility maps Stanford CAP profiles to VIVO.

## Initial Objectives

* Identification of how CAP overlaps with the basics of the VIVO-ISF model
  * specifically as relates to People and their relationships
  * e.g. the LODE and eagle-i views, plus docs and examples on the wiki
* A test case transformation
  * A document mapping CAP profile data to VIVO-ISF
  * Retrieving CAP profile data from the CAP API
  * A transform utility to implement the mapping
* Also investigate CAP publication data
  * consider mapping to both VIVO-ISF and simple BibFrame

### Stanford CAP Resources

- https://cap.stanford.edu/cap-api/console

### VIVO Resources

- http://www.vivoweb.org
- https://wiki.duraspace.org/display/VIVO/VIVO
- https://wiki.duraspace.org/display/VIVO/Major+concepts+in+VIVO+to+get+you+started
- https://wiki.duraspace.org/display/VIVO/VIVO-ISF+Ontology
- https://wiki.duraspace.org/display/VIVO/VIVO-ISF+1.6+Relationship+Diagrams

To stand up a VIVO instance (using vagrant), with some sample data:
- https://github.com/lawlesst/vivo-vagrant
- https://github.com/lawlesst/vivo-sample-data

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cap-vivo-mapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cap-vivo-mapper

## Usage

### Setup

#### MongoDB

The CAP API profile data is retrieved and saved locally into a mongodb database (`cap` by default).  To install mongodb, review their online documentation, e.g.
- http://docs.mongodb.org/master/installation/

#### 4store

The VIVO data can be saved to the a triple store and development work was done with 4store.  To get it running, see the shell script in
https://github.com/sul-dlss/cap-vivo-mapper/blob/master/bin/cap_vivo_4store

After running `cap_vivo_4store` on a Debian/Ubuntu system, there should be a SPARQL server for the `cap_vivo` knowledge base; take a look at
http://localhost:9001/status/.

### Configure and Run Conversion

Use the example configuration in
https://github.com/sul-dlss/cap-vivo-mapper/blob/master/.env_example

```sh
# If it's not already installed, install the the gem.
gem install cap-vivo-mapper
# Create a working directory and create a .env config file. The
# hardest part to the configuration could be getting a CAP API
# account to complete the parameters for client authentication.
mkdir -p ~/tmp/cap_vivo/log
cd ~/tmp/cap_vivo
project='https://raw.githubusercontent.com/sul-dlss/cap-vivo-mapper'
wget ${project}/master/.env_example
cp .env_example .env
vim .env  # hopefully this file is self explanatory
# Run it overnight, unless you have a high bandwidth connection to the
# CAP API and a fast system.  So, watch it for any immediate failures;
# if it's running, leave it for a few hours.
# 1. Copy CAP API data to local mongodb (about 5-10 mins).
cap_download
# 1.b. Optional check of the mongodb collections to ensure it got data.
# 2. Convert the json documents into VIVO RDF data; saved to a local
#    triple store and/or local data files (turtle format).
cap_vivo_convert
```

TODO: add an option to use a VIVO client for the conversion so it can post data directly to a running VIVO instance using the VIVO APIs.  At present, the conversion does not require a running VIVO instance.

### Query the local triple store with VIVO content

When the conversion is done, try to query the triple store.  There is a utility with some pre-baked methods in `cap_vivo_query`, e.g.

```
cap_vivo_query  # loads and starts a ruby pry console
# try the following in the pry console:
#> puts vivo_profile(vivo_uris.sample(1).first).to_ttl 
```


### Loading Output Turtle into VIVO

The output of `cap_vivo_convert` is also saved to individual turtle files in the relative path: `./data/vivo_rdf/`.  There is a utility to concatenate all the turtle data files into one large file; the utility is `cap_vivo_concat_turtle.sh`, which runs the following shell commands:

```sh
rm -f data/vivo_rdf/all*.ttl
cat data/vivo_rdf/*.ttl | grep '@prefix' | sort -u > /tmp/vivo_rdf_prefixes.ttl
cat data/vivo_rdf/*.ttl | grep -v '@prefix' > /tmp/vivo_rdf_all_no_prefixes.ttl
cat /tmp/vivo_rdf_prefixes.ttl /tmp/vivo_rdf_all_no_prefixes.ttl > data/vivo_rdf/all.ttl
rm /tmp/vivo_rdf*.ttl
rapper -c -i turtle data/vivo_rdf/all.ttl
```

The result is a turtle file in `./data/vivo_rdf/all.ttl` which can be input directly into VIVO.

1. Get a VIVO instance using the vagrant project at
  - https://github.com/lawlesst/vivo-vagrant.git
2. When it's running, login as the administrator and go to the 'Site Admin' page (find a link to this at top right of home page).  There is a section for 'Advanced Data Tools' that has a link to 'Add/Remove RDF data'.  On that page, click the 'browse' button to locate a turtle data file.  Leave the default radio button selection at 'add instance data (supports large data files)'.  Click the format selector and choose 'Turtle'.  Then click 'submit'.  If it loads, it will report a success message and then you can nagivate to the home page.

3. Alternately, run the script `./bin/vivo_import_turtle.sh` which loads each .ttl file in `/tmp/cap_vivo_rdf` using the VIVO sparqlUpdate api (see https://wiki.duraspace.org/display/VIVODOC19x/SPARQL+Update+API#SPARQLUpdateAPI-EnablingtheAPI). Run this script from the cap-vivo-mapper app root, which should be installed under the vivo user's home dir:

`USR=joe@stanford.edu PASSWD=secret ./bin/vivo_import_turtle.sh | tee -ai ./log/vivo_import_turtle.log`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/sul-dlss/cap-vivo-mapper.

## License

Copyright 2015 The Board of Trustees of the Leland Stanford Junior University.

The gem is available as open source under the terms of the [Apache 2 License](http://www.apache.org/licenses/LICENSE-2.0).

