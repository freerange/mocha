## Mocha [![build status](https://secure.travis-ci.org/freerange/mocha.png)](https://secure.travis-ci.org/freerange/mocha.png)

### Description

A Ruby library for mocking and stubbing.

It has a unified, simple and readable syntax for both full & partial mocking.

It has built-in support for [MiniTest](https://github.com/seattlerb/minitest) and [Test::Unit](https://github.com/test-unit/test-unit/) and is supported by many other test frameworks, e.g. [RSpec](http://rspec.info/), [bacon](https://github.com/chneukirchen/bacon/), [expectations](http://expectations.rubyforge.org/), [Dust](http://dust.rubyforge.org/) and [JtestR](http://jtestr.codehaus.org/).

### Installation

#### Gem

Install the latest version of the gem with the following command...

    $ gem install mocha

Note that if you are intending to use Mocha with Test::Unit or MiniTest, you should only load Mocha *after* loading the relevant test library...

    require "test/unit"
    require "mocha"

#### Bundler

If you're using Bundler, ensure the correct load order by not auto-requiring Mocha in the `Gemfile` and then load it later once you know the test library has been loaded...

    # Gemfile
    gem "mocha", :require => false

    # Elsewhere after Bundler has loaded gems
    require "test/unit"
    require "mocha"

#### Rails

If you're loading Mocha using Bundler within a Rails application, you should ensure Mocha is not auto-required (as above) and load Mocha manually e.g. at the bottom of your `test_helper.rb`.

    # Gemfile in Rails app
    gem "mocha", :require => false

    # At bottom of test_helper.rb
    require "mocha"

#### Rails Plugin

Install the Rails plugin...

    $ rails plugin install git://github.com/freerange/mocha.git

Note that as of version 0.9.8, the Mocha plugin is not automatically loaded at plugin load time. Instead it must be manually loaded e.g. at the bottom of your `test_helper.rb`.

#### Know Issues

* Versions 0.10.2, 0.10.3 & 0.11.0 of the gem were broken.
* Versions 0.9.6 & 0.9.7 of the Rails plugin were broken.
* Please do not use these versions.

### Examples

* Quick Start - [Usage Examples](/examples/misc.rb)
* Traditional mocking - [Star Trek Example](/examples/mocha.rb)
* Setting expectations on real classes - [Order Example](/examples/stubba.rb)
* More examples on [James Mead's Blog](http://jamesmead.org/blog/)
* [Mailing List Archives](http://groups.google.com/group/mocha-developer)

### Links

* [Source code](http://github.com/freerange/mocha)
* [Bug reports](http://github.com/freerange/mocha/issues)

### Developing Mocha

* Fork the repository.
* Make your changes in a branch (including tests).
* Ensure all of the tests run against all supported versions of Test::Unit, MiniTest & Ruby by running ./build-matrix.rb (note that currently this makes a *lot* of assumptions about your local environment e.g. rbenv installed with specific Ruby versions).
* Send us a pull request from your fork/branch.

### History

Mocha was initially harvested from projects at [Reevoo](http://www.reevoo.com/). It's syntax is heavily based on that of [jMock](http://www.jmock.org).

### Authors

* [James Mead](http://jamesmead.org/)
* [Ben Griffiths](http://www.techbelly.com/)
* [Chris Roos](http://chrisroos.co.uk/)
* [Paul Battley](http://po-ru.com/)
* [Chad Woolley](http://thewoolleyweb.com/)
* [Dan Manges](http://www.dan-manges.com/)
* [Denis Defreyne](http://stoneship.org/)
* [Diego Plentz](http://plentz.org/)
* [Eloy Duran](http://soup.superalloy.nl/)
* [Gleb Pomykalov](https://github.com/glebpom)
* [Holger Just](https://github.com/meineerde)
* [James Sanders](https://github.com/jsanders)
* [Jeff Smick](https://github.com/sprsquish)
* [Jens Fahnenbruck](https://github.com/jigfox)
* [Jeremy Stephens](https://github.com/viking)
* [Julik Tarkhanov](http://julik.nl/)
* [Luke Redpath](http://lukeredpath.co.uk/)
* [Nick Lewis](https://github.com/nicklewis)
* [Prem Sichanugrist](http://sikachu.com/)
* [Saikat Chakrabarti](http://techblog.gomockingbird.com/)
* [Sander Hartlage](https://github.com/sander6)
* [Steven Xu](http://stevenxu.ca/)
* [Taylor Barstow](http://taylorbarstow.com/)
* [Ubiratan Pires Alberton](https://github.com/Bira)
* [Brian L. Troutwine](http://www.troutwine.us/)
* [Red Davis](https://github.com/reddavis)
* [Celestino Gomes](http://blog.tinogomes.com/)

### License

© Copyright Revieworld Ltd. 2006

You may use, copy and redistribute this library under the same terms as [Ruby itself](http://www.ruby-lang.org/en/LICENSE.txt) or under the [MIT license](MIT-LICENSE.rdoc).
