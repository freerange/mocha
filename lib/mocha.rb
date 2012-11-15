require 'mocha/version'
require 'mocha/integration'
require 'mocha/deprecation'

Mocha::Deprecation.warning("Change `require 'mocha'` to `require 'mocha/setup'`.")

require 'mocha/setup'

