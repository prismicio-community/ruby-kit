class Fragments
  class Link
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def asHtml
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

    def asHtml
      "<span class=\"text\">#{@value}</span>"
    end
  end

  class Date
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def asHtml
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

    def asHtml
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

    def asHtml
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

    def asHtml
      "<div data-oembed='#{@url}'
        data-oembed-type='#{@embed_type.downcase}'
        data-oembed-provider='#{@provider.downcase}'>#{@html}</div>"
    end
  end
end
