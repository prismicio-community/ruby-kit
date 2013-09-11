module Prismic
  module Fragments
    class Link
      def as_html
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
      attr_accessor :id, :link_type, :tags, :slug, :is_broken

      def initialize(id, link_type, tags, slug, is_broken)
        @id = id
        @link_type = link_type
        @tags = tags
        @slug = slug
        @is_broken = is_broken
      end

      def as_html(link_resolver)
      end

      alias :broken? :is_broken
    end
  end
end
