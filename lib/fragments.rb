class Fragments
  class Link
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def as_html
      "<a href=\"#{@url}\">#{@url}</a>"
    end
  end

  class WebLink < Link
  end

  class MediaLink < Link
  end

  class Text
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def as_html
      "<span class=\"text\">#{@value}</span>"
    end
  end

  class Date
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def as_html
      "<time>#{value.iso8601(3)}</time>"
    end
  end

  class Number
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def asInt
      @value.to_int
    end

    def as_html
      "<span class=\"number\">#{@value}</span>"
    end
  end

  class Color
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def asRGB
      Fragments::Color.asRGB(@value)
    end

    def self.asRGB(value)
      {
        'red'   => value[0..1].to_i(16),
        'green' => value[2..3].to_i(16),
        'blue'  => value[4..5].to_i(16)
      }
    end

    def as_html
      "<span class=\"color\">#{@value}</span>"
    end

    def self.is_a_valid_color(value)
      hex_color_format = /([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/
      hex_color_format.match(value)
    end
  end

  class Embed
    attr_accessor :embed_type, :provider, :url, :width, :height, :html, :o_embed_json

    def initialize(embed_type, provider, url, width, height, html, o_embed_json)
      @embed_type   = embed_type
      @provider     = provider
      @url          = url
      @width        = width
      @height       = height
      @html         = html
      @o_embed_json = o_embed_json
    end

    def as_html
      "<div data-oembed='#{@url}'
        data-oembed-type='#{@embed_type.downcase}'
        data-oembed-provider='#{@provider.downcase}'>#{@html}</div>"
    end
  end

  class Image
    attr_accessor :main, :views

    def initialize(main, views)
      if views.has_key?('main')
        raise ViewsHasMainKeyException
      end

      @main = main
      @views = views
    end

    def as_html
      @main.as_html
    end

    def get_view(key)
      if key == 'main'
        @main
      else
        (@views.has_key? key) ? @views[key] : (raise ViewDoesNotExistException)
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
  end

  class Image::View
    attr_accessor :url, :width, :height

    def initialize(url, width, height)
      if width == 0
        raise NullWidthException, "A View's with cannot be null"
      elsif height == 0
        raise NullHeightException, "A View's with cannot be null"
      end

      @url = url
      @width = width
      @height = height
    end

    def ratio
      return @width / @height
    end

    def as_html
      "<img src='#{@url}' width='#{@width}' height='#{@height}'>"
    end

    class NullHeightException < Exception
    end
    class NullWidthException < Exception
    end
  end

  class StructuredText
    class Span
      attr_accessor :start, :end

      def initialize(start, end_)
        @start = start
        @end = end_
      end
    end

    class Span::Em < Span
    end

    class Span::Strong < Span
    end

    class Span::Hyperlink < Span
    end
  end

  class Block
    class Text < Block
      attr_accessor :text, :spans

      def initialize(text, spans)
        @text = text
        @spans = spans
      end
    end

    class Heading < Text
      attr_accessor :level

      def initialize(text, spans, level)
        @text = text
        @spans = spans
        @level = level
      end
    end

    class Paragraph < Text
    end

    class ListItem < Text
      attr_accessor :ordered

      def initialize(text, spans, ordered)
        @text = text
        @spans = spans
        @ordered = ordered
      end
    end

    class Image < Block
      attr_accessor :view

      def initialize(view)
        @view = view
      end

      def url
        @view.url
      end

      def width
        @view.width
      end

      def height
        @view.height
      end
    end
  end
end
