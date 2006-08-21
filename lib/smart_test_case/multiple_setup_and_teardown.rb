module MultipleSetupAndTeardown
  
  def self.included(base)

    base.class_eval do
  
      def self.method_added(symbol)
        # disable until later
      end

      if method_defined?(:setup) then
        alias_method :setup_original, :setup
        define_method(:setup_new) do
          begin
            setup_original
          ensure
            setup_mocha
          end
        end
      else
        define_method(:setup_new) do
          setup_mocha
        end
      end
      alias_method :setup, :setup_new

      if method_defined?(:teardown) then
        alias_method :teardown_original, :teardown
        define_method(:teardown_new) do
          begin
            teardown_mocha
          ensure
            teardown_original
          end
        end
      else
        define_method(:teardown_new) do
          teardown_mocha
        end
      end
      alias_method :teardown, :teardown_new

      def self.method_added(method)
        case method
        when :setup
          unless method_defined?(:setup_added)
            alias_method :setup_added, :setup
            define_method(:setup) do
              begin
                setup_new
              ensure
                setup_added
              end
            end
          end
        when :teardown
          unless method_defined?(:teardown_added)
            alias_method :teardown_added, :teardown
            define_method(:teardown) do
              begin
                teardown_added
              ensure
                teardown_new
              end
            end
          end
        end
      end

      class << self

        def setup_methods
          @setup_methods ||= []
        end

        def teardown_methods
          @teardown_methods ||= []
        end

        def add_setup_method(symbol)
          setup_methods << symbol
        end

        def add_teardown_method(symbol)
          teardown_methods << symbol
        end

        private

        def inherited_with_setup_and_teardown_methods(child)
          inherited_without_setup_and_teardown_methods(child) if respond_to?(:inherited_without_setup_and_teardown_methods, true)
          child.instance_variable_set('@setup_methods', setup_methods.dup)
          child.instance_variable_set('@teardown_methods', teardown_methods.dup)
        end

        if respond_to?(:inherited, true)
          alias_method :inherited_without_setup_and_teardown_methods, :inherited
        end
        alias_method :inherited, :inherited_with_setup_and_teardown_methods

      end

      def setup_mocha
        self.class.class_eval { setup_methods }.each { |symbol| send(symbol) }
      end

      def teardown_mocha
        stored_exception = nil
        self.class.class_eval { teardown_methods }.reverse.each do |symbol|
          begin
            send(symbol)
          rescue Exception => e
            stored_exception ||= e
          end
        end
        raise stored_exception if stored_exception
      end

    end

  end

end
