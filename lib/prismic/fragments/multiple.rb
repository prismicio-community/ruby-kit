module Prismic
  module Fragments
    class Multiple
      attr_reader :fragments

      def initialize(fragments=[])
        @fragments = fragments
      end

      def size
        @fragments.size
      end

      def [](i)
        @fragments[i]
      end

      def push(fragment)
        @fragments.push(fragment)
      end

      alias :length :size
    end
  end
end
