# encoding: utf-8
module Prismic
  module Fragments
    class Embed < Fragment
      attr_accessor :embed_type, :provider, :url, :html, :o_embed_json

      def initialize(embed_type, provider, url, html, o_embed_json)
        @embed_type   = embed_type
        @provider     = provider
        @url          = url
        @html         = html
        @o_embed_json = o_embed_json
      end

      # Generate an HTML representation of the fragment
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver=nil, html_serializer=nil)
        %Q|<div data-oembed="#{@url}" data-oembed-type="#{@embed_type.downcase}" data-oembed-provider="#{@provider.downcase}">#@html</div>|
      end
    end
  end
end
