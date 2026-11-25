source 'https://rubygems.org'

gemspec

gem 'danger'
gem 'danger-changelog'
gem 'danger-pr-comment', '0.1.0'
gem 'danger-toc'
gem 'rake'
gem 'rspec', '~> 3.13'

if RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3')
  gem 'rubocop', '~> 1.92'
  gem 'rubocop-md', '~> 3.0', require: false
  gem 'rubocop-prose', '~> 0.2', require: false
  gem 'rubocop-rake', '~> 0.7', require: false
  gem 'rubocop-spellcheck', '~> 0.2', require: false
  gem 'rubocop-yaml', '~> 0.1.0', require: false
end
