# encoding: utf-8
module Prismic
  module Fragments

    # A fragment of type Slice, an item in a SliceZone
    class Slice < Fragment
      attr_accessor :slice_type
      attr_accessor :value

      def initialize(slice_type, value)
        @slice_type = slice_type
        @value = value
      end

      # Generate an text representation of the group
      #
      # @return [String] the text representation
      def as_text
        @value.as_text
      end

      # Generate an HTML representation of the group
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver=nil)
        @value.as_html(link_resolver)
      end
    end

    class SliceZone < Fragment
      attr_accessor :slices

      def initialize(slices)
        @slices = slices
      end

      # Generate an text representation of the group
      #
      # @return [String] the text representation
      def as_text
        @slices.map { |slice| slice.as_text }.join("\n")
      end

      # Generate an HTML representation of the group
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver=nil)
        @slices.map { |slice| slice.as_html(link_resolver) }.join("\n")
      end
    end

  end
end
