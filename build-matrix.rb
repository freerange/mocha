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

RUBY_VERSION_MAP = {
  '1.8.7' => '1.8.7-p371',
  '1.9.3' => '1.9.3-p362',
  '2.0.0' => '2.0.0-p0'
}

travis_config = YAML.load(File.read('.travis.yml'))
build_configs = travis_config['matrix']['include']
build_configs.each do |config|
  ruby_version = config['rvm']
  rbenv_ruby = RUBY_VERSION_MAP[ruby_version]
  gemfile = config['gemfile']
  environment_variables = Hash[*config['env'].split.flat_map { |e| e.split('=') }]
  environment_variables.each { |k, v| ENV[k] = v }
  p [rbenv_ruby, gemfile]
  run(rbenv_ruby, gemfile)
end
