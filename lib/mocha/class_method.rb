require 'mocha/ruby_version'
require 'metaclass'

module Mocha

  class ClassMethod

    PrependedModule = Class.new(Module)

    attr_reader :stubbee, :method

    def initialize(stubbee, method)
      @stubbee = stubbee
      @original_method, @original_visibility = nil, nil
      @method = PRE_RUBY_V19 ? method.to_s : method.to_sym
    end

    def stub
      hide_original_method
      define_new_method
    end

    def unstub
      remove_new_method
      restore_original_method
      mock.unstub(method.to_sym)
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
      if @original_visibility = method_visibility(method)
        begin
          if RUBY_V2_PLUS
            @definition_target = PrependedModule.new
            stubbee.__metaclass__.__send__ :prepend, @definition_target
          else
            @original_method = stubbee._method(method)
            if @original_method && @original_method.owner == stubbee.__metaclass__
              stubbee.__metaclass__.send(:remove_method, method)
            end
          end
        rescue NameError
          # deal with nasties like ActiveRecord::Associations::AssociationProxy
        end
      end
    end

    def define_new_method
      definition_target.class_eval(<<-CODE, __FILE__, __LINE__ + 1)
        def #{method}(*args, &block)
          mocha.method_missing(:#{method}, *args, &block)
        end
      CODE
      if @original_visibility
        Module.instance_method(@original_visibility).bind(definition_target).call(method)
      end
    end

    def remove_new_method
      definition_target.send(:remove_method, method)
    end

    def restore_original_method
      unless RUBY_V2_PLUS
        if @original_method && @original_method.owner == stubbee.__metaclass__
          if PRE_RUBY_V19
            original_method = @original_method
            stubbee.__metaclass__.send(:define_method, method) do |*args, &block|
              original_method.call(*args, &block)
            end
          else
            stubbee.__metaclass__.send(:define_method, method, @original_method)
          end
        end
        if @original_visibility
          Module.instance_method(@original_visibility).bind(stubbee.__metaclass__).call(method)
        end
      end
    end

    def matches?(other)
      return false unless (other.class == self.class)
      (stubbee.object_id == other.stubbee.object_id) and (method == other.method)
    end

    alias_method :==, :eql?

    def to_s
      "#{stubbee}.#{method}"
    end

    def method_visibility(method)
      symbol = method.to_sym
      metaclass = stubbee.__metaclass__

      (metaclass.public_method_defined?(symbol) && :public) ||
        (metaclass.protected_method_defined?(symbol) && :protected) ||
        (metaclass.private_method_defined?(symbol) && :private)
    end

    private

    def definition_target
      @definition_target ||= stubbee.__metaclass__
    end

  end

end
