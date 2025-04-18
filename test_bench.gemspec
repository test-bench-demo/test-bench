# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench'
  s.version = '0.1.0.1'
  s.summary = "Some summary"
  s.description = ' '
  s.homepage = 'http://example.com'
  s.license = 'MIT'

  s.authors = ['Brightworks Digital']
  s.email = 'development@brightworks.digital'

  s.required_ruby_version = ">= 3.0.0"
  s.platform = Gem::Platform::RUBY

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/test-bench-demo/test-bench'

  s.require_paths = %w(lib)
  s.bindir = 'executables'

  s.executables = Dir.glob('executables/*').map { |executable| File.basename(executable) }

  s.files = Dir.glob('lib/**/*')

  s.add_runtime_dependency 'test_bench-fixture'
end
