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

- https://wiki.duraspace.org/display/VIVO/VIVO
- https://wiki.duraspace.org/display/VIVO/Major+concepts+in+VIVO+to+get+you+started
- https://wiki.duraspace.org/display/VIVO/VIVO-ISF+Ontology
- http://www.vivoweb.org/download

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

```sh
# The following worked on an Ubuntu desktop system
sudo apt-get install mongodb
```

#### 4store

```sh
# The following worked on an Ubuntu desktop system
sudo apt-get install 4store
sudo 4store status
sudo service 4store stop
sudo service 4store status
# Only setup the backend once (it erases existing data)
sudo 4s-backend-setup cap_vivo
sudo 4s-backend cap_vivo
sudo 4s-httpd -h # describes the options used below
sudo 4s-httpd -p 9000 -U -s -1 cap_vivo
```

4store should be running a SPARQL server on the `cap_vivo` knowledge base; take a look at http://localhost:9000/status/.

### Configure and Run Conversion

Use the example configuration in
https://github.com/sul-dlss/cap-vivo-mapper/blob/master/.env_example

```sh
mkdir -p ~/tmp/cap_vivo/log
cd ~/tmp/cap_vivo
project='https://raw.githubusercontent.com/sul-dlss/cap-vivo-mapper'
wget ${project}/master/.env_example
cp .env_example .env
vim .env  # hopefully this file is self explanatory
# If it's not already installed, install the the gem.
gem install cap-vivo-mapper
# Run it overnight, unless you have a high bandwidth connection to the
# CAP API and a fast system.  So, watch it for any immediate failures;
# if it's running, then leave it overnight.  The expected runtime is on
# the order of hours.
cap2vivo
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

