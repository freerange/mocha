lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'mocha/version'

DESCRIPTION =
  'A library for mocking and stubbing with a unified, simple and readable syntax ' \
  'for both full & partial mocking. Built-in support for Minitest and Test::Unit. ' \
  'Supported by many other test frameworks, e.g. RSpec.'.freeze

Gem::Specification.new do |s|
  s.name = 'mocha'
  s.version = Mocha::VERSION
  s.licenses = ['MIT', 'BSD-2-Clause']
  s.required_ruby_version = '>= 2.2'

  s.authors = ['James Mead']
  s.description = DESCRIPTION
  s.email = 'mocha-developer@googlegroups.com'

  s.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(docs|test)/}) }
  end
  s.files.delete('.circleci/config.yml')
  s.files.delete('.gitignore')

  s.homepage = 'https://mocha.jamesmead.org'
  s.require_paths = ['lib']
  s.summary = 'Mocking and stubbing library'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/freerange/mocha/issues',
    'changelog_uri' => 'https://github.com/freerange/mocha/blob/main/RELEASE.md',
    'documentation_uri' => 'https://mocha.jamesmead.org/',
    'funding_uri' => 'https://github.com/sponsors/floehopper',
    'homepage_uri' => s.homepage,
    'source_code_uri' => 'https://github.com/freerange/mocha',
    'rubygems_mfa_required' => 'true'
  }

  s.add_dependency 'ruby2_keywords', '>= 0.0.5'
end
