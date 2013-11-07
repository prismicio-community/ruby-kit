# encoding: utf-8
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
        if broken?
          %(<span>#{slug}</span>)
        else
          %(<a href="#{link_resolver.link_to(self)}">#{slug}</a>)
        end
      end

      alias :broken? :broken
    end
  end
end
