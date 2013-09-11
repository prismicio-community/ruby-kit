require 'nokogiri'
require 'yajl'
require 'json'
require 'simplecov'

SimpleCov.start

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'prismic'
