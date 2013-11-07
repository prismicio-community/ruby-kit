# encoding: utf-8
module Prismic
  module Fragments
    class Number
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_int
        @value.to_int
      end

      def as_html(link_resolver=nil)
        %(<span class="number">#@value</span>)
      end
    end
  end
end
