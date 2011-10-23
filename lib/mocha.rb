def test_unit_required
    defined?(Test) && defined?(Test::Unit) && defined?(Test::Unit::TestCase)
end

def minitest_required
    defined?(MiniTest) && defined?(MiniTest::Unit) && defined?(MiniTest::Unit::TestCase)
end

unless test_unit_required || minitest_required
    raise RuntimeError, "Must require mocha *after* requring a test framework."
end

require 'mocha/version'
require 'mocha_standalone'
require 'mocha/configuration'
require 'mocha/integration'
