module StubbingClassMethod
  def method_owner
    stubbee.singleton_class
  end

  def stubbee
    @stubbee ||= Class.new
  end
end
