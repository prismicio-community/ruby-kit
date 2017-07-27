# encoding: utf-8
module Prismic
  module Fragments

    # A fragment of type CompositeSlice, an item in a SliceZone
    class CompositeSlice < Fragment
      attr_accessor :slice_type
      attr_accessor :slice_label
      attr_accessor :non_repeat
      attr_accessor :repeat

      def initialize(slice_type, slice_label, non_repeat, repeat)
        @slice_type = slice_type
        @slice_label = slice_label
        @non_repeat = non_repeat
        @repeat = repeat
      end
    end

    # A fragment of type SimpleSlice, an item in a SliceZone
    class SimpleSlice < Fragment
      attr_accessor :slice_type
      attr_accessor :slice_label
      attr_accessor :value

      def initialize(slice_type, slice_label, value)
        @slice_type = slice_type
        @slice_label = slice_label
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
        classes = ['slice']
        unless (@slice_label.nil?)
          classes.push(@slice_label)
        end
        %[<div data-slicetype="#{@slice_type}" class="#{classes.join(' ')}">#{@value.as_html(link_resolver)}</div>]
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
