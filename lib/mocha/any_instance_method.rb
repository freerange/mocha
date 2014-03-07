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
      if method_exists?(method)
        begin
          if @original_method = stubbee.instance_method(method)
            if stubbee_owns_the_method?
              @method_owner = :stubbee
            elsif prepended_modules_own_the_method?
              @method_owner = :prepended_module
              @original_prepended_method = prepended_module_owning_the_method.instance_method(method)

              prepended_module_owning_the_method.send(:remove_method, method)
              @original_method = stubbee.instance_method(method)
            else
              return
            end

            @original_visibility = :public
            if stubbee.protected_instance_methods.include?(method)
              @original_visibility = :protected
            elsif stubbee.private_instance_methods.include?(method)
              @original_visibility = :private
            end

            stubbee.send(:remove_method, method)
          end
        rescue NameError
          # deal with nasties like ActiveRecord::Associations::AssociationProxy
        end
      end
    end

    def define_new_method
      stubbee.class_eval(<<-CODE, __FILE__, __LINE__ + 1)
        def #{method}(*args, &block)
          self.class.any_instance.mocha.method_missing(:#{method}, *args, &block)
        end
      CODE
    end

    def remove_new_method
      stubbee.send(:remove_method, method)
    end

    def restore_original_method
      if @original_method
        if !@method_owner.nil?
          stubbee.send(:define_method, method, @original_method)
          Module.instance_method(@original_visibility).bind(stubbee).call(method)
        end
        if @method_owner == :prepended_module
          prepended_module_owning_the_method.send(:define_method, method, @original_prepended_method)
        end
      end
    end

    def method_exists?(method)
      return true if stubbee.public_instance_methods(false).include?(method)
      return true if stubbee.protected_instance_methods(false).include?(method)
      return true if stubbee.private_instance_methods(false).include?(method)
      return false
    end

    private

    def stubbee_owns_the_method?
      @original_method.owner == stubbee
    end

    def prepended_module_owning_the_method
      @prepended_module_owning_the_method ||= stubbee_prepended_modules.find { |mod| @original_method.owner == mod }
    end

    def prepended_modules_own_the_method?
      !!prepended_module_owning_the_method
    end

    def stubbee_prepended_modules
      stubbee.ancestors.take_while { |ancestor| ancestor.is_a?(Module) }
    end

  end

end
