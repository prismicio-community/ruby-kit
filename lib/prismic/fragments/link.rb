module Prismic
  module Fragments
    class Link
      def as_html(link_resolver=nil)
        %(<a href="#@url">#@url</a>)
      end
    end

    class WebLink < Link
      attr_accessor :url

      def initialize(url)
        @url = url
      end
    end

    class MediaLink < Link
      attr_accessor :url

      def initialize(url)
        @url = url
      end
    end

    class DocumentLink < Link
      attr_accessor :id, :link_type, :tags, :slug, :broken

      def initialize(id, link_type, tags, slug, broken)
        @id = id
        @link_type = link_type
        @tags = tags
        @slug = slug
        @broken = broken
      end

      def as_html(link_resolver)
      end

      alias :broken? :broken
    end
  end
end
