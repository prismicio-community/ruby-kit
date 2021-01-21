# encoding: utf-8
module Prismic

  # A document with Fragments: usually a Prismic.io Document, or a Document within a Group
  module WithFragments
    # @return [Hash{String => Fragment}]
    attr_accessor :fragments

    # Generate a Text representation of the entire document
    #
    # @return [String] the text representation
    def as_text
      fragments.map { |field, fragment| fragment.as_text }.join("\n")
    end

    # Generate an HTML representation of the entire document
    #
    # @param link_resolver [LinkResolver] The LinkResolver used to build
    #     application's specific URL
    #
    # @return [String] the HTML representation
    def as_html(link_resolver)
      fragments.map { |field, fragment|
        %(<section data-field="#{field}">#{fragment.as_html(link_resolver)}</section>)
      }.join("\n")
    end

    # Finds the first highest title in a document (if any)
    #
    # @return [String]
    def first_title
      # It is impossible to reuse the StructuredText.first_title method, since
      # we need to test the highest title across the whole document
      title = false
      max_level = 6 # any title with a higher level kicks the current one out
      @fragments.each do |_, fragment|
        if fragment.is_a? Prismic::Fragments::StructuredText
          fragment.blocks.each do |block|
            if block.is_a?(Prismic::Fragments::StructuredText::Block::Heading)
              if block.level < max_level
                title = block.text
                max_level = block.level # new maximum
              end
            end
          end
        end
      end
      title
    end

    # Get a document's field
    # @return [Fragments::Fragment]
    def [](field)
      array = field.split('.')
      if array.length != 2
        raise ArgumentError, 'Argument should contain one dot. Example: product.price'
      end
      return nil if array[0] != self.type
      fragments[array[1]]
    end
    alias :get :[]

    # @yieldparam name [String]
    # @yieldparam fragment [Fragment]
    def each(&blk)
      @fragments.each(&blk)
    end
    include Enumerable  # adds map, select, etc

    # @return [Fixum]
    def length
      @fragments.length
    end
    alias :size :length

    # @return [Fragments::StructuredText]
    def get_structured_text(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::StructuredText
      fragment
    end

    # @return [Fragments::Text]
    def get_text(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Text
      fragment
    end

    # @return [Fragments::Number]
    def get_number(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Number
      fragment
    end

    # @return [Fragments::Image]
    def get_image(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Image
      fragment
    end

    # @return [Fragments::Date]
    def get_date(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Date
      fragment
    end

    # @return [Fragments::Timestamp]
    def get_timestamp(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Timestamp
      fragment
    end

    # @return [Fragments::Group]
    def get_group(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Group
      fragment
    end

    # @return [Fragments::Link]
    def get_link(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Link
      fragment
    end

    # @return [Fragments::Embed]
    def get_embed(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Embed
      fragment
    end

    # @return [Fragments::Color]
    def get_color(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::Color
      fragment
    end

    # @return [Fragments::GeoPoint]
    def get_geopoint(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::GeoPoint
      fragment
    end

    def get_slice_zone(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::SliceZone
      fragment
    end

    # @return [Fragments::BooleanField]
    def get_boolean_field(field)
      fragment = self[field]
      return nil unless fragment.is_a? Prismic::Fragments::BooleanField
      fragment
    end

    # @return [Array<LinkedDocument>]
    def linked_documents
      self.fragments.map { |name, fragment|
        if fragment.is_a? Prismic::Fragments::DocumentLink
          [fragment]
        elsif fragment.is_a? Prismic::Fragments::StructuredText
          fragment.blocks
            .select { |block| block.is_a? Prismic::Fragments::StructuredText::Block::Text}
            .map { |block| block.spans }.flatten
            .select { |span| span.is_a? Prismic::Fragments::StructuredText::Span::Hyperlink }
            .map { |span| span.link }
            .select { |link| link.is_a? Prismic::Fragments::DocumentLink }
        elsif fragment.is_a? Prismic::Fragments::Group
          fragment.group_documents
            .map { |groupDoc| groupDoc.linked_documents }
            .flatten
        else
          []
        end
      }.flatten
    end
  end

end
