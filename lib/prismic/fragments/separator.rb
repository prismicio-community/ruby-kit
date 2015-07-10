# encoding: utf-8
module Prismic
  module Fragments
    class Separator < Fragment
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_html(link_resolver=nil)
        %(<hr class="separator" />)
      end

      def as_text
        @value
      end
    end
  end
end
