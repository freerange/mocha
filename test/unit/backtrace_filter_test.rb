require File.expand_path('../../test_helper', __FILE__)
require 'mocha/backtrace_filter'

class BacktraceFilterTest < Mocha::TestCase
  include Mocha

  def test_should_exclude_mocha_locations_from_backtrace
    mocha_lib = '/username/workspace/mocha_wibble/lib'
    backtrace = ["#{mocha_lib}/exclude/me/1", "#{mocha_lib}/exclude/me/2", '/keep/me', "#{mocha_lib}/exclude/me/3"]
    filter = BacktraceFilter.new(mocha_lib)
    assert_equal ['/keep/me'], filter.filtered(backtrace)
  end

  def test_should_determine_path_for_mocha_lib_directory
    assert_match Regexp.new('/lib/$'), BacktraceFilter::LIB_DIRECTORY
  end

  def test_should_handle_special_characters
    lib_directory = '/tmp/bundle/ruby/3.2.0+3/gems/mocha-2.0.2/lib'
    filter = BacktraceFilter.new(lib_directory)
    backtrace = ['/keep/me', "#{lib_directory}/mocha/deprecation.rb"]
    assert_equal ['/keep/me'], filter.filtered(backtrace)
  end
end
