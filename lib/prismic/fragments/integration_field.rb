module Prismic
  module Fragments
    class IntegrationField < Fragment
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_json
        value.to_json
      end

      def as_text
        value.to_s
      end
    end
  end
end
