# encoding: utf-8
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'nokogiri'
begin
  require 'yajl/json_gem'
rescue LoadError
  # ok not a big deal
  require 'json'
end
require 'simplecov'

RSpec.configure do |c|
  # Stop after the first failure
  # c.fail_fast = true
end

SimpleCov.start

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'prismic'
