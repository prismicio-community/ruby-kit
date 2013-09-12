module Prismic
  module Fragments
    class Date
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_html
        %(<time>#{value.iso8601(3)}</time>)
      end
    end

    class Number
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def as_int
        @value.to_int
      end

      def as_html
        %(<span class="number">#@value</span>)
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
        %(<span class="color">#@value</span>)
      end

      def self.valid?(value)
        /(\h{2})(\h{2})(\h{2})/ ===  value
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
        <<-HTML
        <div data-oembed="#@url"
            data-oembed-type="#{@embed_type.downcase}"
            data-oembed-provider="#{@provider.downcase}">#@html</div>
        HTML
      end
    end
  end
end

require 'prismic/fragments/block'
require 'prismic/fragments/image'
require 'prismic/fragments/link'
require 'prismic/fragments/structured_text'
require 'prismic/fragments/text'
