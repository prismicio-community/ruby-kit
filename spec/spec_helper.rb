# encoding: utf-8
require 'nokogiri'
begin
  require 'yajl/json_gem'
rescue LoadError
  # ok not a big deal
  require 'json'
end
require 'simplecov'

SimpleCov.start

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'prismic'
