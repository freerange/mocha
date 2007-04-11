STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS = Object.public_instance_methods

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))

require 'test/unit'