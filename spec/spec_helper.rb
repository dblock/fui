$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rspec'
require 'tmpdir'
require 'fui'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end
