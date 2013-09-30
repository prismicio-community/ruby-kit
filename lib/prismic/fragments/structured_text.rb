module Prismic
  module Fragments
    class StructuredText
      attr_accessor :blocks

      def initialize(blocks)
        @blocks = blocks
      end

      def as_html(link_resolver)
        blocks.map{|b| b.as_html(link_resolver) }.join
      end

      class Span
        attr_accessor :start, :end

        def initialize(start, finish)
          @start = start
          @end = finish
        end

        class Em < Span
        end

        class Strong < Span
        end

        class Hyperlink < Span
          attr_accessor :link
          def initialize(start, finish, link)
            @start = start
            @end = finish
            @link = link
          end
        end
      end

      class Block
        class Text
          attr_accessor :text, :spans

          def initialize(text, spans)
            @text = text
            @spans = spans
          end

          def as_html(link_resolver=nil)
            text
          end
        end

        class Heading < Text
          attr_accessor :level

          def initialize(text, spans, level)
            @text = text
            @spans = spans
            @level = level
          end

          def as_html(link_resolver=nil)
            %(<h#{level}>#{text}</h#{level}>)
          end
        end

        class Paragraph < Text
          def as_html(link_resolver=nil)
            %(<p>#{super}</p>)
          end
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
end
