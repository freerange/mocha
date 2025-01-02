# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/object_receiver'

class ObjectReceiverTest < Mocha::TestCase
  include Mocha

  class FakeObject
    def initialize(mocha)
      @mocha = mocha
    end

    def mocha(_instantiate)
      @mocha
    end

    def is_a?(_klass)
      false
    end
  end

  class FakeClass
    attr_reader :superclass

    def initialize(superclass, mocha)
      @superclass = superclass
      @mocha = mocha
    end

    def mocha(_instantiate)
      @mocha
    end

    def is_a?(klass)
      klass == Class
    end
  end

  def test_mocks_returns_mock_for_object
    object = FakeObject.new(:mocha)
    receiver = ObjectReceiver.new(object)
    assert_equal [:mocha], receiver.mocks
  end

  def test_mocks_returns_mocks_for_class_and_its_superclasses
    grandparent = FakeClass.new(nil, :grandparent_mocha)
    parent = FakeClass.new(grandparent, :parent_mocha)
    klass = FakeClass.new(parent, :mocha)
    receiver = ObjectReceiver.new(klass)
    assert_equal [:mocha, :parent_mocha, :grandparent_mocha], receiver.mocks
  end
end
