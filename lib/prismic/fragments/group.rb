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

      # The array of the fragment lists
      attr_accessor :fragment_list_array

      def initialize(fragment_list_array)
        @fragment_list_array = fragment_list_array
      end

      # Accessing the i-th item (fragment list) of the group: `group[i]`
      def [](i)
        @fragment_list_array[i]
      end
      alias :get :[]

      # @yieldparam fragment [Fragment]
      def each(&blk)
        @fragment_list_array.each(&blk)
      end
      include Enumerable  # adds map, select, etc

      def length
        @fragment_list_array.length
      end
      alias :size :length

      # Generate an HTML representation of the group
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver = nil)
        @fragment_list_array.map { |fl| fl.as_html(link_resolver) }.join("\n")
      end

      # Generate an text representation of the group
      #
      # @return [String] the text representation
      def as_text
        @fragment_list_array.map { |fl| fl.as_text }.join("\n")
      end


      class FragmentMapping

        # a hash containing all the fragments in the fragment list
        attr_accessor :fragments

        def initialize(fragments)
          @fragments = fragments
        end

        # Accessing the right fragment of the fragment list: `fl['caption']`
        def [](name)
          @fragments[name]
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

        # Generate an HTML representation of the fragments
        #
        # @param link_resolver [LinkResolver] The LinkResolver used to build
        #     application's specific URL
        #
        # @return [String] the HTML representation
        def as_html(link_resolver = nil)
          @fragments.map { |name, fragment|
            %(<section data-field="#{name}">#{fragment.as_html(link_resolver)}</section>)
          }.join("\n")
        end

        # Generate a text representation of the fragment
        #
        # @return [String] the text representation
        def as_text
          @fragments.values.map { |fragment| fragment.as_text }.join("\n")
        end
      end
    end
  end
end
