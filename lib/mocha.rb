require 'mocha/version'
require 'mocha/deprecation'

Mocha::Deprecation.warning("Change `require 'mocha'` to `require 'mocha/setup'`.")

require 'mocha/setup'

