module StubbingInstanceMethod
  def method_owner
    stubbee.class
  end

  def stubbee
    @stubbee ||= Class.new.new
  end
end
