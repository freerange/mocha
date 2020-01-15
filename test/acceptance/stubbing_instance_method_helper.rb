module StubbingInstanceMethodHelper
  def method_owner
    stub_owner.class
  end

  def stub_owner
    @stub_owner ||= Class.new.new
  end
end
