# This is not meant to be run by itself. It will be run by bacon_test.rb
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))
require 'bacon'
require 'mocha'

module MetaTestOutput
  def handle_specification(name)
    yield
  end

  def handle_requirement(description)
    yield
  end

  def handle_summary
    puts
    puts Bacon::ErrorLog  if Bacon::Backtraces
    puts "%d tests, %d assertions, %d failures, %d errors" %
      Bacon::Counter.values_at(:specifications, :requirements, :failed, :errors)
  end

end

Bacon.extend MetaTestOutput
Bacon.summary_on_exit

describe "Bacon specs using Mocha" do
  should "pass when all expectations were fulfilled" do
    mockee = mock()
    mockee.expects(:blah)
    mockee.blah
  end

  should "fail when not all expectations were fulfilled" do
    mockee = mock()
    mockee.expects(:blah)
  end

  should "fail when there is an unexpected invocation" do
    mockee = mock()
    mockee.blah
  end

  should "pass when they receive all expected parameters" do
    mockee = mock()
    mockee.expects(:blah).with(has_key(:wibble))
    mockee.blah(:wibble => 1)
  end

  should "fail when they receive unexpected parameters" do
    mockee = mock()
    mockee.expects(:blah).with(has_key(:wibble))
    mockee.blah(:wobble => 2)
  end

  should "pass when all Stubba expectations are fulfilled" do
    stubbee = Class.new { define_method(:blah) {} }.new
    stubbee.expects(:blah)
    stubbee.blah
  end

  should "fail when not all Stubba expectations were fulfilled" do
    stubbee = Class.new { define_method(:blah) {} }.new
    stubbee.expects(:blah)
  end

end
