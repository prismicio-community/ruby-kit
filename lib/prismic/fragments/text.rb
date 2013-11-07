# encoding: utf-8
module Prismic
  module Fragments
    class Text
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_html(link_resolver=nil)
        %(<span class="text">#{CGI::escapeHTML(@value)}</span>)
      end
    end
  end
end
