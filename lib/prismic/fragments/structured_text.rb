# encoding: utf-8
module Prismic
  module Fragments
    class StructuredText < Fragment

      # Used during the call of {StructuredText#as_html} : blocks are first gathered by groups,
      # so that list items of the same list are placed within the same group, allowing to frame
      # their serialization with <ul>...</ul> or <ol>...</ol>.
      # Images, paragraphs, headings, embed, ... are then placed alone in their own BlockGroup.
      class BlockGroup
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

      # Serializes the current StructuredText fragment into a fully usable HTML code.
      # You need to pass a proper link_resolver so that internal links are turned into the proper URL in
      # your website. If you use a starter kit, one is provided, that you can still update later.
      #
      # This method simply executes the as_html methods on blocks;
      # it is not advised to override this method if you want to change the HTML output, you should
      # override the as_html method at the block level (like {Heading.as_html}, or {Preformatted.as_html},
      # for instance).
      def as_html(link_resolver)
        # Defining blocks that deserve grouping, assigning them "group kind" names
        block_group = ->(block){
          case block
          when Block::ListItem
            block.ordered? ? "ol" : "ul"
          else
            nil
          end
        }
        # Initializing groups, which is an array of BlockGroup objects
        groups, last = [], nil
        blocks.each {|block|
          group = block_group.(block)
          groups << BlockGroup.new(group) if !last || group != last
          groups.last << block
          last = group
        }
        # HTML-serializing the groups object (delegating the serialization of Block objects),
        # without forgetting to frame the BlockGroup objects right if needed
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

      # Returns the StructuredText as plain text, with zero formatting.
      # Non-textual blocks (like images and embeds) are simply ignored.
      #
      # @param separator [String] The string separator inserted between the blocks (a blank space by default)
      # @return [String] The complete string representing the textual value of the StructuredText field.
      def as_text(separator=' ')
        blocks.map{|block| block.as_text }.compact.join(separator)
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
          def end_html
            "</em>"
          end
        end

        class Strong < Span
          def start_html(link_resolver=nil)
            "<strong>"
          end
          def end_html
            "</strong>"
          end
        end
        
        class Hyperlink < Span
          attr_accessor :link
          def initialize(start, finish, link)
            super(start, finish)
            @link = link
          end
          def start_html(link_resolver = nil)
            link.start_html(link_resolver)
          end
          def end_html
            link.end_html
          end
        end
      end

      class Block

        # Returns nil, as a block is not textual by default.
        # This is meant to be overriden by textual blocks (see Prismic::Fragments::StructuredText::Block::Text.as_text, for instance)
        #
        # @return nil, always.
        def as_text
          nil
        end

        class Text
          attr_accessor :text, :spans

          def initialize(text, spans)
            @text = text
            @spans = spans.select{|span| span.start < span.end}
          end

          def as_html(link_resolver=nil)
            # Getting Hashes of spanning tags to insert, sorted by starting position, and by ending position
            start_spans, end_spans = prepare_spans
            # All the positions in which we'll have to insert an opening or closing tag
            all_cuts = (start_spans.keys | end_spans.keys).sort

            # Initializing the browsing of the string
            output = []
            cursor = 0

            # Taking each text cut and inserting the closing tags and the opening tags if needed
            all_cuts.each do |cut|
              output << CGI::escapeHTML(text[cursor, cut-cursor])
              output << end_spans[cut].map{|span| span.end_html} # this pushes an array into the array; we'll need to flatten later
              output << start_spans[cut].map{|span| span.start_html(link_resolver)} # this pushes an array into the array; we'll need to flatten later
              cursor = cut # cursor is now where the cut was
            end

            # Inserting what's left of the string, if there is something
            output << text[cursor..-1]

            # Making the array into a string
            output.flatten.join

          end

          # Building two span Hashes:
          #  * start_spans, with the starting positions as keys, and spans as values
          #  * end_spans, with the ending positions as keys, and spans as values
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

          # Zero-formatted textual value of the block.
          #
          # @return The textual value.
          def as_text
            @text
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

          def link_to
            @view.link_to
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
