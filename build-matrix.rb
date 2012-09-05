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

def with_rbenv(command)
  %{export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; #{command}}
end

def run(gemfile, task = "test")
  ENV["BUNDLE_GEMFILE"] = gemfile
  ENV["MOCHA_OPTIONS"] = "debug"
  ENV["MOCHA_NO_DOCS"] = "true"
  reset_bundle
  execute(
    with_rbenv("bundle install --gemfile=#{gemfile}"),
    with_rbenv("bundle exec rake #{task}")
  )
end

EXCLUDED_RUBY_193_GEMFILES = [
  "gemfiles/Gemfile.minitest.1.3.0",
  "gemfiles/Gemfile.minitest.1.4.0",
  "gemfiles/Gemfile.minitest.1.4.1",
  "gemfiles/Gemfile.minitest.1.4.2"
]

RUBY_VERSIONS = ["1.8.7-p352", "1.9.3-p125-perf"]

RUBY_VERSIONS.each do |ruby_version|
  execute("rbenv local #{ruby_version}")
  reset_bundle
  run("Gemfile")
  execute("rbenv local --unset")
end

RUBY_VERSIONS.each do |ruby_version|
  execute("rbenv local #{ruby_version}")
  ["test-unit", "minitest"].each do |test_library|
    reset_bundle
    (Dir["gemfiles/Gemfile.#{test_library}.*"] + ["Gemfile"]).each do |gemfile|
      ruby_version_without_patch = ruby_version.split("-")[0]
      next if (ruby_version_without_patch == "1.9.3") && EXCLUDED_RUBY_193_GEMFILES.include?(gemfile)
      next if (ruby_version_without_patch == "1.8.7") && (gemfile == "Gemfile") && (test_library == "minitest")
      p [ruby_version_without_patch, test_library, gemfile]
      ENV['MOCHA_RUN_INTEGRATION_TESTS'] = test_library
      run(gemfile)
    end
  end
  execute("rbenv local --unset")
end
