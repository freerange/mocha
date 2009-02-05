unless defined?(STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS)
  STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS = Object.public_instance_methods
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit', 'parameter_matchers'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'acceptance'))

if ENV['MOCHA_OPTIONS'] == 'use_test_unit_gem'
  gem 'test-unit'
end

require 'test/unit'