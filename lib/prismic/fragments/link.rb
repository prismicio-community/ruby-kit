module Prismic
  module Fragments
    class Link
      attr_accessor :url

      def initialize(url)
        @url = url
      end

      def as_html
        %(<a href="#@url">#@url</a>)
      end
    end

    class WebLink < Link
    end

    class MediaLink < Link
    end
  end
end
