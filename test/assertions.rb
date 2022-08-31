module Assertions
  def assert_method_visibility(object, method_name, visibility)
    assert object.send("#{visibility}_methods").include?(method_name), "#{method_name} is not #{visibility}"
  end
end
