module Prismic
  module Fragments
    class StructuredText
      class Span
        attr_accessor :start, :end

        def initialize(start, finish)
          @start = start
          @end = finish
        end

        def as_html
        end
      end

      class Span::Em < Span
      end

      class Span::Strong < Span
      end

      class Span::Hyperlink < Span
      end
    end
  end
end
