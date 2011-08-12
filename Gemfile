source :rubygems

gemspec

test_unit_version = ENV["TEST_UNIT_VERSION"]
group :development do
  if "latest" == test_unit_version
    gem "test-unit"
  elsif !test_unit_version.nil? && !test_unit_version.empty?
    gem "test-unit", test_unit_version
  end
end