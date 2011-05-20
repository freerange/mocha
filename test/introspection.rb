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

  class InstanceSnapshot
    attr_reader :methods

    def initialize(instance)
      ancestors = [instance.__metaclass__] + instance.class.ancestors
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

  class ClassSnapshot
    attr_reader :methods

    def initialize(klass)
      @methods = Set.new(
        klass.__metaclass__.ancestors.map do |meta_ancestor|
          meta_ancestor.public_instance_methods(false).map { |method| Method.new(meta_ancestor, method, :public) } +
          meta_ancestor.protected_instance_methods(false).map { |method| Method.new(meta_ancestor, method, :protected) } +
          meta_ancestor.private_instance_methods(false).map { |method| Method.new(meta_ancestor, method, :private) }
        end.flatten +
        klass.ancestors.map do |ancestor|
          (ancestor.__metaclass__.public_instance_methods(false) - ancestor.__metaclass__.ancestors.map { |a| a.public_instance_methods(false) }.flatten - (ancestor.ancestors - [ancestor]).map { |a| a.public_methods(false) }).flatten.map { |method| Method.new(ancestor, method, :public) } +
          (ancestor.__metaclass__.protected_instance_methods(false) - ancestor.__metaclass__.ancestors.map { |a| a.protected_instance_methods(false) }.flatten - (ancestor.ancestors - [ancestor]).map { |a| a.protected_methods(false) }).flatten.map { |method| Method.new(ancestor, method, :protected) } +
          (ancestor.__metaclass__.private_instance_methods(false) - ancestor.__metaclass__.ancestors.map { |a| a.private_instance_methods(false) }.flatten - (ancestor.ancestors - [ancestor]).map { |a| a.private_methods(false) }).flatten.map { |method| Method.new(ancestor, method, :private) }
        end.flatten
      )
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
    def assert_instance_snapshot_unchanged(instance)
      before = Introspection::InstanceSnapshot.new(instance)
      yield
      after = Introspection::InstanceSnapshot.new(instance)
      assert !before.changed?(after), "Instance snapshot has changed: #{before.diff(after).inspect}"
    end
    def assert_class_snapshot_unchanged(klass)
      before = Introspection::InstanceSnapshot.new(klass)
      yield
      after = Introspection::InstanceSnapshot.new(klass)
      assert !before.changed?(after), "Class snapshot has changed: #{before.diff(after).inspect}"
    end
  end
end
