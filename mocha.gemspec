Gem::Specification.new do |s|
  s.name   = "mocha"
  s.summary = "Mocking and stubbing library"
  s.version = Mocha::VERSION
  s.platform = Gem::Platform::RUBY
  s.author = 'James Mead'
  s.description = <<-EOF
    Mocking and stubbing library with JMock/SchMock syntax, which allows mocking and stubbing of methods on real (non-mock) classes.
  EOF
  s.email = 'mocha-developer@rubyforge.org'
  s.homepage = 'http://mocha.rubyforge.org'
  s.rubyforge_project = 'mocha'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'COPYING']
  s.rdoc_options << '--title' << 'Mocha' << '--main' << 'README' << '--line-numbers'
                         
  s.autorequire = 'mocha'
  s.add_dependency('rake')
  s.files = FileList['{lib,test,examples}/**/*.rb', '[A-Z]*'].exclude('TODO').to_a
end
