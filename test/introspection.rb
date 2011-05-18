require 'set'

module Introspection

  class Method
    attr_reader :owner, :name, :visibility

    def initialize(owner, name, visibility)
      @owner, @name, @visibility = owner, name, visibility
    end

    def eql?(other)
      (self.class === other) && (owner == other.owner) && (name == other.name) && (visibility == other.visibility)
    end

    def hash
      [owner, name, visibility].hash
    end

    def inspect
      "#{owner}##{name} (#{visibility})"
    end
  end

  class Snapshot
    attr_reader :methods

    def initialize(instance)
      ancestors = [instance.__metaclass__] + instance.class.ancestors - [Object, Kernel]
      @methods = Set.new(ancestors.map do |ancestor|
        ancestor.public_instance_methods(false).map { |method| Method.new(ancestor, method, :public) } +
        ancestor.protected_instance_methods(false).map { |method| Method.new(ancestor, method, :protected) } +
        ancestor.private_instance_methods(false).map { |method| Method.new(ancestor, method, :private) }
      end.flatten)
    end

    def diff(other)
      {
        :added => (other.methods - methods).to_a,
        :removed => (methods - other.methods).to_a
      }
    end

    def changed?(other)
      diff(other).values.flatten.any?
    end
  end

  module Assertions
    def assert_snapshot_unchanged(instance)
      before = Introspection::Snapshot.new(instance)
      yield
      after = Introspection::Snapshot.new(instance)
      assert !before.changed?(after), "Instance snapshot has changed: #{before.diff(after).inspect}"
    end
  end
end
