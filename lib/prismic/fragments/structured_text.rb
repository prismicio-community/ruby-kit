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
      def as_html(link_resolver, html_serializer=nil)
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
          html = group.blocks.map { |b|
            b.as_html(link_resolver, html_serializer)
          }.join
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

        class Label < Span
          attr_accessor :label
          def initialize(start, finish, label)
            super(start, finish)
            @label = label
          end
          def serialize(text, link_resolver = nil)
            "<span class=\"#{@label}\">#{text}</span>"
          end
        end

        class Em < Span
          def serialize(text, link_resolver = nil)
            "<em>#{text}</em>"
          end
        end

        class Strong < Span
          def serialize(text, link_resolver = nil)
            "<strong>#{text}</strong>"
          end
        end

        class Hyperlink < Span
          attr_accessor :link
          def initialize(start, finish, link)
            super(start, finish)
            @link = link
          end
          def serialize(text, link_resolver = nil)
            if link.is_a? Prismic::Fragments::DocumentLink and link.broken
              "<span>#{text}</span>"
            else
              %(<a href="#{link.url(link_resolver)}">#{text}</a>)
            end
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
          attr_accessor :text, :spans, :label

          def initialize(text, spans, label = nil)
            @text = text
            @spans = spans.select{|span| span.start < span.end}
            @label = label
          end

          def class_code
            (@label && %( class="#{label}")) || ''
          end

          def as_html(link_resolver=nil, html_serializer=nil)
            html = ''
            # Getting Hashes of spanning tags to insert, sorted by starting position, and by ending position
            start_spans, end_spans = prepare_spans
            # Open tags
            stack = Array.new
            (text.length + 1).times do |pos| # Looping to length + 1 to catch closing tags
              end_spans[pos].each do |t|
                # Close a tag
                tag = stack.pop
                inner_html = serialize(tag[:span], tag[:html], link_resolver, html_serializer)
                if stack.empty?
                  # The tag was top-level
                  html += inner_html
                else
                  # Add the content to the parent tag
                  stack[-1][:html] += inner_html
                end
              end
              start_spans[pos].each do |tag|
                # Open a tag
                stack.push({
                    :span => tag,
                    :html => ''
                })
              end
              if pos < text.length
                if stack.empty?
                  # Top level text
                  html += CGI::escapeHTML(text[pos])
                else
                  # Inner text of a span
                  stack[-1][:html] += CGI::escapeHTML(text[pos])
                end
              end
            end
            html
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
              # Make sure the spans are sorted bigger first to respect the hierarchy
              @start_spans = start_spans.each { |_, spans| spans.sort! { |a, b| b.end - b.start <=> a.end - a.start } }
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

          def serialize(elt, text, link_resolver, html_serializer)
            custom_html = html_serializer && html_serializer.serialize(elt, text)
            if custom_html.nil?
              elt.serialize(text, link_resolver)
            else
              custom_html
            end
          end

          private :class_code
        end

        class Heading < Text
          attr_accessor :level

          def initialize(text, spans, level, label = nil)
            super(text, spans)
            @level = level
          end

          def as_html(link_resolver=nil, html_serializer=nil)
            custom_html = html_serializer && html_serializer.serialize(self, super)
            if custom_html.nil?
              %(<h#{level}#{class_code}>#{super}</h#{level}>)
            else
              custom_html
            end
          end
        end

        class Paragraph < Text
          def as_html(link_resolver=nil, html_serializer=nil)
            custom_html = html_serializer && html_serializer.serialize(self, super)
            if custom_html.nil?
              %(<p#{class_code}>#{super}</p>)
            else
              custom_html
            end
          end
        end

        class Preformatted < Text
          def as_html(link_resolver=nil, html_serializer=nil)
            custom_html = html_serializer && html_serializer.serialize(self, super)
            if custom_html.nil?
              %(<pre#{class_code}>#{super}</pre>)
            else
              custom_html
            end
          end
        end

        class ListItem < Text
          attr_accessor :ordered
          alias :ordered? :ordered

          def initialize(text, spans, ordered, label = nil)
            super(text, spans)
            @ordered = ordered
          end

          def as_html(link_resolver, html_serializer=nil)
            custom_html = html_serializer && html_serializer.serialize(self, super)
            if custom_html.nil?
              %(<li#{class_code}>#{super}</li>)
            else
              custom_html
            end
          end
        end

        class Image < Block
          attr_accessor :view, :label

          def initialize(view, label = nil)
            @view = view
            @label = label
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

          def as_html(link_resolver, html_serializer = nil)
            custom = nil
            unless html_serializer.nil?
              custom = html_serializer.serialize(self, '')
            end
            if custom.nil?
              classes = ['block-img']
              unless @label.nil?
                classes.push(@label)
              end
              %(<p class="#{classes.join(' ')}">#{view.as_html(link_resolver)}</p>)
            else
              custom
            end
          end
        end

        class Embed < Block
          attr_accessor :label

          def initialize(embed, label)
            @embed = embed
            @label = label
          end

          def as_html(link_resolver, html_serializer = nil)
            custom = nil
            unless html_serializer.nil?
              custom = html_serializer.serialize(self, '')
            end
            if custom.nil?
              embed.as_html(link_resolver)
            else
              custom
            end
          end

        end

      end
    end
  end
end
