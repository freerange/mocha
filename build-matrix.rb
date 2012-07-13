#!/usr/bin/env ruby

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

def run(gemfile)
  ENV["BUNDLE_GEMFILE"] = gemfile
  ENV["MOCHA_OPTIONS"] = "debug"
  reset_bundle
  execute(
    "bundle install --gemfile=#{gemfile}",
    "bundle exec rake test"
  )
end

EXCLUDED_MINITEST_GEMFILES = [
  "gemfiles/Gemfile.minitest.1.3.0",
  "gemfiles/Gemfile.minitest.1.4.0",
  "gemfiles/Gemfile.minitest.1.4.1",
  "gemfiles/Gemfile.minitest.1.4.2",
  "gemfiles/Gemfile.test-unit.latest",
]

reset_bundle
Dir["gemfiles/Gemfile.*"].each do |gemfile|
  next if (RUBY_VERSION == "1.9.3") && EXCLUDED_MINITEST_GEMFILES.include?(gemfile)
  p [RUBY_VERSION, gemfile]
  run(gemfile)
end
