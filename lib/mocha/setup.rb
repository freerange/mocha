require 'mocha/integration'
require 'mocha/deprecation'

Mocha::Deprecation.warning(
  "Use `require 'mocha/test_unit'` or `require 'mocha/minitest'` instead."
)

module Mocha
  def self.activate
    Integration.activate
  end
end

Mocha.activate
