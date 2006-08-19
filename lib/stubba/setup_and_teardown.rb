require 'stubba/central'

module SetupAndTeardown
  
  def self.included(base)
    base.add_setup_method(:setup_stubs)
    base.add_teardown_method(:teardown_stubs)
  end
  
  def setup_stubs
    $stubba = Stubba::Central.new
  end
  
  def teardown_stubs
    if $stubba then
      begin
        $stubba.verify_all { add_assertion }
      ensure
        $stubba.unstub_all
        $stubba = nil
      end
    end
  end

end
