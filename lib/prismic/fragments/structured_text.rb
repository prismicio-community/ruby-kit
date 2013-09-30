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
          def start_html(link_resolver=nil)
            "<em>"
          end
          def end_html(link_resolver=nil)
            "</em>"
          end
        end

        class Strong < Span
          def start_html(link_resolver=nil)
            "<b>"
          end
          def end_html(link_resolver=nil)
            "</b>"
          end
        end

        class Hyperlink < Span
          attr_accessor :link
          def initialize(start, finish, link)
            super(start, finish)
            @link = link
          end
          def start_html(link_resolver)
            # Quick-and-dirty way to generate the right <a> tag
            link.as_html(link_resolver).sub(/(<a[^>]+>).*/, '\1')
          end
          def end_html(link_resolver=nil)
            "</a>"
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
            start_spans, end_spans = prepare_spans
            text.chars.each_with_index.map {|c, i|
              opening = start_spans[i].map {|span|
                span.start_html(link_resolver)
              }
              closing = end_spans[i].map {|span|
                span.end_html(link_resolver)
              }
              opening + closing + [c]
            }.flatten.join("")
          end

          def prepare_spans
            unless defined?(@prepared_spans)
              start_spans = Hash.new{|h,k| h[k] = [] }
              end_spans = Hash.new{|h,k| h[k] = [] }
              spans.each {|span|
                start_spans[span.start] << span
                end_spans[span.end] << span
              }
              @start_spans = start_spans
              @end_spans = end_spans
            end
            [@start_spans, @end_spans]
          end
        end

        class Heading < Text
          attr_accessor :level

          def initialize(text, spans, level)
            super(text, spans)
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
            super(text, spans)
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
