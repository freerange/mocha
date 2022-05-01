module StubbingAnyInstanceMethod
  def method_owner
    @method_owner ||= Class.new
  end

  def stubbee
    method_owner.any_instance
  end
end
