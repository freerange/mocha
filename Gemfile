source :rubygems

gemspec

test_unit_version = ENV["TEST_UNIT_VERSION"]
if !test_unit_version.nil? && !test_unit_version.empty?
  group :development do
    gem "test-unit", test_unit_version
  end
end