# encoding: utf-8
module Prismic
  module Fragments
    class Link < Fragment

      def start_html(link_resolver = nil, target = nil)
        unless target.nil?
          %(<a href="#{url(link_resolver)}" target="#{target}" rel="noopener">)
        else 
          %(<a href="#{url(link_resolver)}">)
        end
      end

      def end_html
        %(</a>)
      end

      def as_html(link_resolver=nil)
        %(#{start_html(link_resolver, @target)}#{url(link_resolver)}#{end_html})
      end

      # Returns the URL of the link
      #
      # @abstract See {WebLink#url}, {FileLink#url}, {ImageLink#url} or {DocumentLink#url}
      #
      # @param link_resolver [LinkResolver] The link resolver
      def url(link_resolver = nil)
        raise NotImplementedError, "Method #{__method__} is not implemented for #{inspect}", caller
      end

    end

    class WebLink < Link
      attr_accessor :url, :target

      def initialize(url, target = nil)
        @url = url
        @target = target
      end

      # Returns the URL of the link
      #
      # @note The link_resolver parameter is accepted but it is not used by
      #       this method, so not providing it is perfectly fine.
      #
      # @see Link#url
      #
      # @param link_resolver [LinkResolver] The link resolver
      def url(link_resolver = nil)
        @url
      end
    end

    class FileLink < Link
      attr_accessor :url, :name, :kind, :size, :target

      def initialize(url, name, kind, size, target = nil)
        @url = url
        @name = name
        @kind = kind
        @size = size
        @target = target
      end

      def as_html(link_resolver=nil)
        %(#{start_html(link_resolver)}#@name#{end_html})
      end

      # Returns the URL of the link
      #
      # @note The link_resolver parameter is accepted but it is not used by
      #       this method, so not providing it is perfectly fine.
      #
      # @see Link#url
      #
      # @param link_resolver [LinkResolver]
      def url(link_resolver = nil)
        @url
      end

    end

    class ImageLink < Link
      attr_accessor :url, :target

      def initialize(url, target = nil)
        @url = url
        @target = target
      end

      # Returns the URL of the link
      #
      # @note The link_resolver parameter is accepted but it is not used by
      #       this method, so not providing it is perfectly fine.
      #
      # @see Link#url
      #
      # @param link_resolver [LinkResolver]
      def url(link_resolver=nil)
        @url
      end
    end

    class DocumentLink < Link
      include Prismic::WithFragments
      attr_accessor :id, :uid, :type, :tags, :slug, :lang, :fragments, :broken, :target

      def initialize(id, uid, type, tags, slug, lang, fragments, broken, target = nil)
        @id = id
        @uid = uid
        @type = type
        @tags = tags
        @slug = slug
        @lang = lang
        @fragments = fragments
        @broken = broken
        @target = target
      end

      def start_html(link_resolver, target = nil)
        broken? ? %(<span>) : super
      end

      def end_html
        broken? ? %(</span>) : super
      end

      def as_html(link_resolver=nil)
        %(#{start_html(link_resolver)}#{slug}#{end_html})
      end

      def link_type
        warn('WARNING: DocumentLink.link_type is deprecated, use DocumentLink.type instead')
        self.type
      end

      # Returns the URL of the link
      #
      # @overload url(link_resolver)
      #
      # @see Link#url
      #
      # @param link_resolver [LinkResolver]
      def url(link_resolver = nil)
        raise "A link_resolver method is needed to serialize document links into a correct URL on your website. If you're using a starter kit, a trivial one is provided out-of-the-box, that you can update later." if link_resolver == nil
        link_resolver.link_to(self)
      end

      alias :broken? :broken
    end
  end
end
