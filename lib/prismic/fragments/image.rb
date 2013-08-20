module Prismic
  module Fragments
    class Image
      attr_accessor :main, :views

      def initialize(main, views)
        @main = main
        @views = views
      end

      def as_html
        main.as_html
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
        attr_accessor :url, :width, :height

        def initialize(url, width, height)
          @url = url
          @width = width
          @height = height
        end

        def ratio
          return @width / @height
        end

        def as_html
          %(<img src="#@url" width="#@width" height="#@height">)
        end

      end

    end
  end
end
