module Assertions
  def assert_method_visibility(object, method_name, visiblity)
    method_key = method_name.to_sym
    assert object.send("#{visiblity}_methods").include?(method_key), "#{method_name} is not #{visiblity}"
  end
end
