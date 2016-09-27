require 'mocha/ruby_version'
require 'metaclass'

module Mocha

  class ClassMethod

    PrependedModule = Class.new(Module)

    attr_reader :stubbee, :method_name

    def initialize(stubbee, method_name)
      @stubbee = stubbee
      @original_method, @original_visibility = nil, nil
      @method_name = PRE_RUBY_V19 ? method_name.to_s : method_name.to_sym
    end

    def stub
      hide_original_method
      define_new_method
    end

    def unstub
      remove_new_method
      restore_original_method
      mock.unstub(method_name.to_sym)
      unless mock.any_expectations?
        reset_mocha
      end
    end

    def mock
      stubbee.mocha
    end

    def reset_mocha
      stubbee.reset_mocha
    end

    def hide_original_method
      if @original_visibility = method_visibility(method_name)
        begin
          if RUBY_V2_PLUS
            prepend_module
          else
            @original_method = original_method(method_name)
            if original_method_defined_on_stubbee?
              remove_original_method_from_stubbee
            end
          end
        rescue NameError
          # deal with nasties like ActiveRecord::Associations::AssociationProxy
        end
      end
    end

    def define_new_method
      definition_target.class_eval(*stub_method_definition)
      if @original_visibility
        Module.instance_method(@original_visibility).bind(definition_target).call(method_name)
      end
    end

    def remove_new_method
      definition_target.send(:remove_method, method_name)
    end

    def restore_original_method
      unless RUBY_V2_PLUS
        if @original_method && @original_method.owner == stubbee.__metaclass__
          if PRE_RUBY_V19
            original_method = @original_method
            stubbee.__metaclass__.send(:define_method, method_name) do |*args, &block|
              original_method.call(*args, &block)
            end
          else
            stubbee.__metaclass__.send(:define_method, method_name, @original_method)
          end
        end
        if @original_visibility
          Module.instance_method(@original_visibility).bind(stubbee.__metaclass__).call(method_name)
        end
      end
    end

    def matches?(other)
      return false unless (other.class == self.class)
      (stubbee.object_id == other.stubbee.object_id) and (method_name == other.method_name)
    end

    alias_method :==, :eql?

    def to_s
      "#{stubbee}.#{method_name}"
    end

    def method_visibility(method_name)
      symbol = method_name.to_sym
      metaclass = stubbee.__metaclass__

      (metaclass.public_method_defined?(symbol) && :public) ||
        (metaclass.protected_method_defined?(symbol) && :protected) ||
        (metaclass.private_method_defined?(symbol) && :private)
    end

    private

    def original_method(method_name)
      stubbee._method(method_name)
    end

    def original_method_defined_on_stubbee?
      @original_method && @original_method.owner == stubbee.__metaclass__
    end

    def remove_original_method_from_stubbee
      stubbee.__metaclass__.send(:remove_method, method_name)
    end

    def prepend_module
      @definition_target = PrependedModule.new
      stubbee.__metaclass__.__send__ :prepend, @definition_target
    end

    def stub_method_definition
      filename, line_number_of_method_implementation = __FILE__, __LINE__ + 2
      method_implementation = <<-CODE
      def #{method_name}(*args, &block)
        mocha.method_missing(:#{method_name}, *args, &block)
      end
      CODE
      [method_implementation, filename, line_number_of_method_implementation]
    end

    def definition_target
      @definition_target ||= default_definition_target
    end

    def default_definition_target
      stubbee.__metaclass__
    end

  end

end
