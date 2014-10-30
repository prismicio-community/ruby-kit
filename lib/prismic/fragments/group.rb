# encoding: utf-8
module Prismic
  module Fragments

    # A fragment of type Group, which contains an array of FragmentList (which
    # itself is a Hash of fragments).
    #
    # For instance, imagining this group is defined with two possible fragments:
    # an image fragment "image", and a text fragment "caption"; then accessing
    # the first image will look like this: `group[0]['image']`.
    class Group < Fragment

      # The array of group documents
      attr_accessor :group_documents

      def initialize(group_documents)
        @group_documents = group_documents
      end

      # Get the group document corresponding to index
      # @return [Prismic::WithFragments]
      def [](index)
        @group_documents[index]
      end

      alias :get :[]
      # @yieldparam group_doc [WithFragment]
      def each(&blk)
        @group_documents.each(&blk)
      end
      include Enumerable  # adds map, select, etc

      def length
        @group_documents.length
      end
      alias :size :length

      # Generate an HTML representation of the group
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver = nil)
        @group_documents.map { |doc| doc.as_html(link_resolver) }.join("\n")
      end

      # Generate an text representation of the group
      #
      # @return [String] the text representation
      def as_text
        @group_documents.map { |doc| doc.as_text }.join("\n")
      end

    end
  end
end
