$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rspec'
require 'tmpdir'
require 'fui'
require 'English'

RSpec.configure(&:raise_errors_for_deprecations!)
