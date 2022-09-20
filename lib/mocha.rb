require 'mocha/version'
require 'mocha/ruby_version'
require 'mocha/deprecation'

unless Mocha::RUBY_V2_PLUS
  Mocha::Deprecation.warning(
    'Versions of Ruby earlier than v2.0 will not be supported in future versions of Mocha.'
  )
end
