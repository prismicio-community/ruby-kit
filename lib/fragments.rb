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
end
