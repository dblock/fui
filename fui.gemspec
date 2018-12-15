$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'fui/version'

Gem::Specification.new do |s|
  s.name = 'fui'
  s.bindir = 'bin'
  s.executables << 'fui'
  s.version = Fui::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.email = 'dblock@dblock.org'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files = Dir['{bin,lib}/**/*'] + Dir['*.md']
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/dblock/fui'
  s.licenses = ['MIT']
  s.summary = 'Find unused Objective-C imports.'
  s.add_dependency 'gli'
  s.required_ruby_version = '>= 1.9.3'
end
