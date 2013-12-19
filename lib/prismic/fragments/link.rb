# encoding: utf-8
module Prismic
  module Fragments
    class Link < Fragment

      def start_html(link_resolver = nil)
        %(<a href="#@url">)
      end

      def end_html(link_resolver = nil)
        %(</a>)
      end

      def as_html(link_resolver=nil)
        %(#{start_html(link_resolver)}#@url#{end_html(link_resolver)})
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

      def start_html(link_resolver)
        raise "A link_resolver method is needed to serialize document links into a correct URL on your website. If you're using a starter kit, a trivial one is provided out-of-the-box, that you can update later." if link_resolver == nil
        broken? ? %(<span>) : %(<a href="#{link_resolver.link_to(self)}">)
      end

      def end_html(link_resolver = nil)
        broken? ? %(</span>) : %(</a>)
      end

      def as_html(link_resolver=nil)
        %(#{start_html(link_resolver)}#{slug}#{end_html(link_resolver)})
      end

      alias :broken? :broken
    end
  end
end
