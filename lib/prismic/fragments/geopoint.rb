# encoding: utf-8
module Prismic
  module Fragments
    class GeoPoint < Fragment
      attr_accessor :longitude, :latitude

      def initialize(longitude, latitude)
        @longitude = longitude
        @latitude = latitude
      end

      # Generate an HTML representation of the fragment
      #
      # @param link_resolver [LinkResolver] The LinkResolver used to build
      #     application's specific URL
      #
      # @return [String] the HTML representation
      def as_html(link_resolver=nil)
        %(<div class="geopoint"><span class="longitude">#@longitude</span><span class="latitude">#@latitude</span></div>)
      end

    end
  end
end
