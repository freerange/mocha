require 'mocha/version'
require 'mocha/configuration'

module Mocha
  # Allows setting of configuration options. See {Configuration} for the available options.
  #
  # Typically the configuration is set globally in a +test_helper.rb+ or +spec_helper.rb+ file.
  #
  # @see Configuration
  #
  # @yieldparam configuration [Configuration] the configuration for modification
  #
  # @example Setting multiple configuration options
  #   Mocha.configure do |c|
  #     c.stubbing_method_unnecessarily = :prevent
  #     c.stubbing_method_on_non_mock_object = :warn
  #     c.stubbing_method_on_nil = :allow
  #   end
  #
  def self.configure
    yield configuration
  end

  # @private
  def self.configuration
    Configuration.configuration
  end
end
