#!/usr/bin/env ruby

require 'yaml'

def execute(*commands)
  commands.each do |command|
    system(command)
    unless $?.success?
      message = [
        "Executing shell command failed.",
        "  Command: #{command}",
        "  Status:  #{$?.exitstatus}"
      ].join("\n")
      raise message
    end
  end
end

def reset_bundle
  execute(
    "rm -rf .bundle/gems",
    "rm -rf gemfiles/.bundle/gems",
    "rm -f *.lock",
    "rm -f gemfiles/*.lock"
  )
end

def with_rbenv(command)
  %{export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; #{command}}
end

def run(ruby_version, gemfile, task = "test")
  ENV["RBENV_VERSION"] = ruby_version
  ENV["BUNDLE_GEMFILE"] = gemfile
  ENV["MOCHA_OPTIONS"] = "debug"
  ENV["MOCHA_NO_DOCS"] = "true"
  reset_bundle
  execute(
    with_rbenv("bundle install --gemfile=#{gemfile}"),
    with_rbenv("bundle exec rake #{task}"),
  )
end

travis_config = YAML.load(File.read('.travis.yml'))
build_configs = travis_config['matrix']['include']
build_configs.each do |config|
  ruby_version = config['rvm']
  gemfile = config['gemfile']
  environment_variables = Hash[*config['env'].split.flat_map { |e| e.split('=') }]
  environment_variables.each { |k, v| ENV[k] = v }
  p [ruby_version, gemfile]
  run(ruby_version, gemfile)
end
