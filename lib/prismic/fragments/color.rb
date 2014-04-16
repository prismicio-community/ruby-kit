# encoding: utf-8
module Prismic
  module Fragments
    class Color < Fragment
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      # Returns the RGB values in a Hash
      #
      # @example
      #   color.asRGB  # => {'red' => 123, 'green' => 123, 'blue' => 123}
      #
      # @return [Hash]
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

      # Generate an HTML representation of the fragment
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver=nil)
        %(<span class="color">##@value</span>)
      end

      def self.valid?(value)
        /(\h{2})(\h{2})(\h{2})/ ===  value
      end
    end
  end
end
