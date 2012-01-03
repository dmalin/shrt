require 'rubygems'
require 'tempfile'
require 'rspec'
require 'rake'
require 'yaml'
#require 'vcr'
require 'ruby-debug'
# 
# VCR.config do |c|
#   c.cassette_library_dir  = File.join(File.dirname(File.expand_path(__FILE__)), "vcr")
#   c.stub_with :webmock
# end

require File.join(File.dirname(File.expand_path(__FILE__)), "..", "lib", "shrt")
