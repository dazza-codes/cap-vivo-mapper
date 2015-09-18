# Cap::Vivo::Mapper

This utility maps Stanford CAP profiles to VIVO.

## Initial Objectives

* Identification of how CAP overlaps with the basics of the VIVO-ISF model
  * specifically as relates to People and their relationships
  * e.g. the LODE and eagle-i views, plus docs and examples on the wiki
* A test case transformation
  * A document mapping CAP person data to VIVO-ISF
  * A json transform utility to implement the mapping
  * Retrieving CAP profile data from the CAP API
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

The VIVO data is saved to the 4store triple store.  To get it running, see the shell script in
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
cap_vivo_convert
# When it's done, try to look at some samples
cap_vivo_query  # loads and starts a pry console
# try the following in the pry console:
#> puts vivo_profile(vivo_uris.sample(1).first).to_ttl 
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/sul-dlss/cap-vivo-mapper.

## License

Copyright 2015 The Board of Trustees of the Leland Stanford Junior University.

The gem is available as open source under the terms of the [Apache 2 License](http://www.apache.org/licenses/LICENSE-2.0).

