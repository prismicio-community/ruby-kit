module Prismic
  module Fragments
    class Image
      attr_accessor :main, :views

      def initialize(main, views)
        raise ViewsHasMainKeyException if views.has_key?('main')
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

      class ViewsHasMainKeyException < Exception
        def initialize
          super("An additional view cannot be called main. Please use the field " +
                "Fragments::Image.main for this purpose.")
        end
      end

      class ViewDoesNotExistException < Exception
      end

      class View
        attr_accessor :url, :width, :height

        def initialize(url, width, height)
          raise NullWidthException, "A View's with cannot be null" if width == 0
          raise NullHeightException, "A View's with cannot be null" if height == 0
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

        class NullSizeException < Exception ; end
        class NullHeightException < NullSizeException ; end
        class NullWidthException < NullSizeException ; end
      end

    end
  end
end
