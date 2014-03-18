require 'metaclass'

module Mocha

  class ClassMethod

    attr_reader :stubbee, :method

    def initialize(stubbee, method)
      @stubbee = stubbee
      @original_method, @original_visibility = nil, nil
      @method = RUBY_VERSION < '1.9' ? method.to_s : method.to_sym
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
      if method_exists?(method)
        begin
          @original_method = fetch_method_from_stubbee
          save_prepended_modules_and_methods

          @original_visibility = :public
          if stubbee.__metaclass__.protected_instance_methods.include?(method)
            @original_visibility = :protected
          elsif stubbee.__metaclass__.private_instance_methods.include?(method)
            @original_visibility = :private
          end
          if @original_method && @original_method.owner == stubbee.__metaclass__
            stubbee.__metaclass__.send(:remove_method, method)
          end
        rescue NameError
          # deal with nasties like ActiveRecord::Associations::AssociationProxy
        end
      end
    end

    def define_new_method
      stubbee.__metaclass__.class_eval(<<-CODE, __FILE__, __LINE__ + 1)
        def #{method}(*args, &block)
          mocha.method_missing(:#{method}, *args, &block)
        end
      CODE
      if @original_visibility
        Module.instance_method(@original_visibility).bind(stubbee.__metaclass__).call(method)
      end
    end

    def remove_new_method
      stubbee.__metaclass__.send(:remove_method, method)
    end

    def restore_original_method
      if @original_method && @original_method.owner == stubbee.__metaclass__
        if RUBY_VERSION < '1.9'
          original_method = @original_method
          stubbee.__metaclass__.send(:define_method, method) do |*args, &block|
            original_method.call(*args, &block)
          end
        else
          stubbee.__metaclass__.send(:define_method, method, @original_method)
        end
        restore_prepended_methods
      end
      if @original_visibility
        Module.instance_method(@original_visibility).bind(stubbee.__metaclass__).call(method)
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

    def method_exists?(method)
      symbol = method.to_sym
      __metaclass__ = stubbee.__metaclass__
      __metaclass__.public_method_defined?(symbol) || __metaclass__.protected_method_defined?(symbol) || __metaclass__.private_method_defined?(symbol)
    end

    private

    def save_prepended_modules_and_methods
      return if @original_method.owner == stubbee

      @prepended_modules_and_methods = []

      while stubbee_prepended_modules.include?(@original_method.owner)
        owner = @original_method.owner
        meth  = owner.instance_method(method)
        @prepended_modules_and_methods << [owner, meth]

        @original_method.owner.send(:remove_method, method)
        @original_method = fetch_method_from_stubbee
      end
    end

    def restore_prepended_methods
      @prepended_modules_and_methods.reverse_each do |mod, method_definition|
        mod.send(:define_method, method, method_definition)
      end if defined?(@prepended_modules_and_methods)
    end

    def fetch_method_from_stubbee
      stubbee._method(method)
    end

    def stubbee_prepended_modules
      @prepended_modules ||= stubbee.__metaclass__.ancestors.take_while { |ancestor| ancestor.class == Module }
    end
  end

end
