# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/receivers'

class AnyInstanceReceiverTest < Mocha::TestCase
  include Mocha

  class FakeAnyInstanceClass
    class AnyInstance
      def initialize(mocha)
        @mocha = mocha
      end

      def mocha(_instantiate)
        @mocha
      end
    end

    attr_reader :superclass

    def initialize(superclass, mocha)
      @superclass = superclass
      @mocha = mocha
    end

    def any_instance
      AnyInstance.new(@mocha)
    end
  end

  def test_mocks_returns_mocks_for_class_and_its_superclasses
    grandparent = FakeAnyInstanceClass.new(nil, :grandparent_mocha)
    parent = FakeAnyInstanceClass.new(grandparent, :parent_mocha)
    klass = FakeAnyInstanceClass.new(parent, :mocha)
    receiver = AnyInstanceReceiver.new(klass)
    assert_equal [:mocha, :parent_mocha, :grandparent_mocha], receiver.mocks
  end
end

class DefaultReceiverTest < Mocha::TestCase
  include Mocha

  def test_mocks_returns_mock
    mock = :mocha
    receiver = DefaultReceiver.new(mock)
    assert_equal [:mocha], receiver.mocks
  end
end
