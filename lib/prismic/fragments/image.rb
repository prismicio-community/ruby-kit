# encoding: utf-8
module Prismic
  module Fragments
    class Image
      attr_accessor :main, :views

      def initialize(main, views)
        @main = main
        @views = views
      end

      def as_html(link_resolver=nil)
        main.as_html(link_resolver)
      end

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

      class View
        attr_accessor :url, :width, :height, :alt, :copyright

        def initialize(url, width, height, alt, copyright)
          @url = url
          @width = width
          @height = height
          @alt = alt
          @copyright = copyright
        end

        def ratio
          return @width / @height
        end

        def as_html(link_resolver=nil)
          %(<img src="#@url")+(alt == nil ? "" : %( alt="#@alt"))+%( width="#@width" height="#@height" />)
        end

      end
    end
  end
end
