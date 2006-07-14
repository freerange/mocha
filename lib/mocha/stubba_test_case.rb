require 'mocha/stubba'

class Test::Unit::TestCase
    
  def self.method_added(method)
    # disable until we finish messing about
  end
  
  def setup_with_stubba
    $stubba = Stubba.new
  end
  
  def teardown_with_stubba
    $stubba.unstub_all
    $stubba = nil
  end

  if method_defined?(:setup) then
    alias_method :setup_pre_stubba, :setup
    define_method(:setup_post_stubba) do
      setup_pre_stubba
      setup_with_stubba
    end
  else
    define_method(:setup_post_stubba) do
      setup_with_stubba
    end
  end  
  alias_method :setup, :setup_post_stubba
  
  if method_defined?(:teardown) then
    alias_method :teardown_pre_stubba, :teardown
    define_method(:teardown_post_stubba) do
      teardown_with_stubba
      teardown_pre_stubba
    end
  else
    define_method(:teardown_post_stubba) do
      teardown_with_stubba
    end
  end
  alias_method :teardown, :teardown_post_stubba
  
  def self.method_added(method)
    case method
    when :setup
      unless method_defined?(:setup_without_stubba)
        alias_method :setup_without_stubba, :setup
        define_method(:setup) do
          setup_post_stubba
          setup_without_stubba
        end
      end
    when :teardown
      unless method_defined?(:teardown_without_stubba)
        alias_method :teardown_without_stubba, :teardown
        define_method(:teardown) do
          teardown_without_stubba
          teardown_post_stubba
        end
      end
    end
  end

end
