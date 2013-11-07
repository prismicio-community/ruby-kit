# encoding: utf-8
module Prismic
  module Fragments
    class Color
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def asRGB
        Fragments::Color.asRGB(@value)
      end

      def self.asRGB(value)
        {
          'red'   => value[0..1].to_i(16),
          'green' => value[2..3].to_i(16),
          'blue'  => value[4..5].to_i(16)
        }
      end

      def as_html(link_resolver=nil)
        %(<span class="color">##@value</span>)
      end

      def self.valid?(value)
        /(\h{2})(\h{2})(\h{2})/ ===  value
      end
    end
  end
end
