# encoding: utf-8
module Prismic
  module Fragments
    class StructuredText
      class Group
        attr_reader :kind, :blocks
        def initialize(kind)
          @kind = kind
          @blocks = []
        end
        def <<(block)
          blocks << block
        end
      end
      attr_accessor :blocks

      def initialize(blocks)
        @blocks = blocks
      end

      def as_html(link_resolver)
        block_group = ->(block){
          case block
          when Block::ListItem
            block.ordered? ? "ol" : "ul"
          else
            nil
          end
        }
        groups, last = [], nil
        blocks.each {|block|
          group = block_group.(block)
          groups << Group.new(group) if !last || group != last
          groups.last << block
          last = group
        }
        groups.map{|group|
          html = group.blocks.map{|b| b.as_html(link_resolver) }.join
          case group.kind
          when "ol"
            %(<ol>#{html}</ol>)
          when "ul"
            %(<ul>#{html}</ul>)
          else
            html
          end
        }.join("\n\n")
      end

      # Finds the first highest title in a structured text
      def first_title
        max_level = 6 # any title with a higher level kicks the current one out
        title = false
        @blocks.each do |block|
          if block.is_a?(Prismic::Fragments::StructuredText::Block::Heading)
            if block.level < max_level
              title = block.text
              max_level = block.level # new maximum
            end
          end
        end
        title
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
            "<strong>"
          end
          def end_html(link_resolver=nil)
            "</strong>"
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
            link.as_html(link_resolver).sub(/(<[^>]+>).*/, '\1')
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
              opening + closing + [CGI::escapeHTML(c)]
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
            %(<h#{level}>#{super}</h#{level}>)
          end
        end

        class Paragraph < Text
          def as_html(link_resolver=nil)
            %(<p>#{super}</p>)
          end
        end

        class Preformatted < Text
          def as_html(link_resolver=nil)
            %(<pre>#{super}</pre>)
          end
        end

        class ListItem < Text
          attr_accessor :ordered
          alias :ordered? :ordered

          def initialize(text, spans, ordered)
            super(text, spans)
            @ordered = ordered
          end

          def as_html(link_resolver)
            %(<li>#{super}</li>)
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

          def alt
            @view.alt
          end

          def copyright
            @view.copyright
          end

          def as_html(link_resolver)
            view.as_html(link_resolver)
          end
        end

        class Embed < Block

          def initialize(embed)
            @embed
          end

          def as_html(link_resolver)
            embed.as_html(link_resolver)
          end

        end

      end
    end
  end
end
