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

TODO: usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/sul-dlss/cap-vivo-mapper.

## License

Copyright 2015 The Board of Trustees of the Leland Stanford Junior University.

The gem is available as open source under the terms of the [Apache 2 License](http://www.apache.org/licenses/LICENSE-2.0).

