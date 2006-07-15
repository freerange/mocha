class Object
  
  def replace_stubba(stubba, &block)
    original_stubba = $stubba
    begin
      $stubba = stubba
      block.call
    ensure
      $stubba = original_stubba
    end
  end

end