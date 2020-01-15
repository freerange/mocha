module StubbingAnyInstanceMethod
  def method_owner
    @method_owner ||= Class.new
  end

  def stub_owner
    method_owner.any_instance
  end
end
