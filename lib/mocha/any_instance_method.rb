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
            save_prepended_modules_and_methods unless stubbee_owns_the_method?


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
        stubbee.send(:define_method, method, @original_method)
        Module.instance_method(@original_visibility).bind(stubbee).call(method)

        @prepended_modules_and_methods.reverse_each do |mod, method_definition|
          mod.send(:define_method, method, method_definition)
        end if defined?(@prepended_modules_and_methods)
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

    def save_prepended_modules_and_methods
      @prepended_modules_and_methods = []

      begin
        @prepended_modules_and_methods << [
          @original_method.owner,
          @original_method.owner.instance_method(method)
        ]

        @original_method.owner.send(:remove_method, method)
        @original_method = stubbee.instance_method(method)
      end while @original_method.owner.class == Module
    end

  end

end
