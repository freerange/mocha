module StubbingClassMethodHelper
  def method_owner
    stub_owner.singleton_class
  end

  def stub_owner
    @stub_owner ||= Class.new
  end
end
