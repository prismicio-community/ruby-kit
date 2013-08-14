module Prismic
  module Fragments
    class Block
      class Text < Block
        attr_accessor :text, :spans

        def initialize(text, spans)
          @text = text
          @spans = spans
        end
      end

      class Heading < Text
        attr_accessor :level

        def initialize(text, spans, level)
          @text = text
          @spans = spans
          @level = level
        end
      end

      class Paragraph < Text
      end

      class ListItem < Text
        attr_accessor :ordered

        def initialize(text, spans, ordered)
          @text = text
          @spans = spans
          @ordered = ordered
        end
      end

      class Image < Block
        attr_accessor :view

        def initialize(view)
          @view = view
        end

        def url
          @view.url
        end

        def width
          @view.width
        end

        def height
          @view.height
        end
      end
    end
  end
end
