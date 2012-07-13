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

def run(gemfile)
  ENV["BUNDLE_GEMFILE"] = gemfile
  ENV["MOCHA_OPTIONS"] = "debug"
  reset_bundle
  execute(
    with_rbenv("bundle install --gemfile=#{gemfile}"),
    with_rbenv("bundle exec rake test")
  )
end

EXCLUDED_RUBY_193_GEMFILES = [
  "gemfiles/Gemfile.minitest.1.3.0",
  "gemfiles/Gemfile.minitest.1.4.0",
  "gemfiles/Gemfile.minitest.1.4.1",
  "gemfiles/Gemfile.minitest.1.4.2"
]

["1.8.7-p352", "1.9.3-p125-perf"].each do |ruby_version|
  execute("rbenv local #{ruby_version}")
  ["test-unit", "minitest"].each do |test_library|
    reset_bundle
    Dir["gemfiles/Gemfile.#{test_library}.*"].each do |gemfile|
      ruby_version_without_patch = ruby_version.split("-")[0]
      next if (ruby_version_without_patch == "1.9.3") && EXCLUDED_RUBY_193_GEMFILES.include?(gemfile)
      p [ruby_version_without_patch, test_library, gemfile]
      run(gemfile)
    end
  end
  execute("rbenv local --unset")
end
