require 'nokogiri'
begin
  require 'yajl'
rescue LoadError
  # ok not a big deal
end
require 'json'
require 'simplecov'

SimpleCov.start

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'prismic'
