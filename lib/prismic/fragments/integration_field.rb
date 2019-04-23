module Prismic
  module Fragments
    class IntegrationField < Fragment
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_html
        "<p>#{as_text}</p>"
      end

      def as_text
        value.to_s
      end
    end
  end
end
