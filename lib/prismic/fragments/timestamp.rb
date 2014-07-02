# encoding: utf-8
module Prismic
  module Fragments
    class Timestamp < Fragment
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      # Generate an HTML representation of the fragment
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver=nil)
        %(<time>#{value.iso8601(3)}</time>)
      end
    end
  end
end
