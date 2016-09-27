require 'mocha/ruby_version'
require 'mocha/class_method'

module Mocha

  class AnyInstanceMethod < ClassMethod

    def mock
      stubbee.any_instance.mocha
    end

    def reset_mocha
      stubbee.any_instance.reset_mocha
    end

    def hide_original_method
      if @original_visibility = method_visibility(method)
        begin
          @original_method = stubbee.instance_method(method)
          if RUBY_V2_PLUS
            @definition_target = PrependedModule.new
            stubbee.__send__ :prepend, @definition_target
          else
            if @original_method && @original_method.owner == stubbee
              stubbee.send(:remove_method, method)
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
          self.class.any_instance.mocha.method_missing(:#{method}, *args, &block)
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
        if @original_method && @original_method.owner == stubbee
          stubbee.send(:define_method, method, @original_method)
          Module.instance_method(@original_visibility).bind(stubbee).call(method)
        end
      end
    end

    def method_visibility(method)
      (stubbee.public_instance_methods(true).include?(method) && :public) ||
        (stubbee.protected_instance_methods(true).include?(method) && :protected) ||
        (stubbee.private_instance_methods(true).include?(method) && :private)
    end

    private

    def definition_target
      @definition_target ||= stubbee
    end

  end

end
