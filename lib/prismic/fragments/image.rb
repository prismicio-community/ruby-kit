# encoding: utf-8
module Prismic
  module Fragments
    class Image < Fragment
      attr_accessor :main, :views

      def initialize(main, views)
        @main = main
        @views = views
      end

      def as_html(link_resolver=nil)
        main.as_html(link_resolver)
      end

      def as_text
        ""
      end

      def url() main.url end
      def width() main.width end
      def height() main.height end
      def alt() main.alt end
      def copyright() main.copyright end

      def get_view(key)
        if key == 'main'
          main
        elsif @views.has_key?(key)
          views[key]
        else
          raise ViewDoesNotExistException
        end
      end

      class ViewDoesNotExistException < Error ; end

      class View < Fragment
        attr_accessor :url, :width, :height, :alt, :copyright, :link_to

        def initialize(url, width, height, alt, copyright, link_to)
          @url = url
          @width = width
          @height = height
          @alt = alt
          @copyright = copyright
          @link_to = link_to
        end

        def ratio
          return @width / @height
        end

        def as_html(link_resolver=nil)
          html = []
          html << (link_to.nil? ? '' : link_to.start_html(link_resolver))
          html << %(<img src="#@url" alt="#@alt" width="#@width" height="#@height" />)
          html << (link_to.nil? ? '' : link_to.end_html)
          html.join
        end

      end
    end
  end
end
