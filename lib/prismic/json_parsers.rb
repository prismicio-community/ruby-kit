module Prismic
  module JsonParser
    def self.document_link_parser(json)
      Prismic::Fragments::DocumentLink.new(
        json['value']['document']['id'],
        json['value']['document']['type'],
        json['value']['document']['tags'],
        json['value']['document']['slug'],
        json['value']['isBroken'])
    end

    def self.text_parser(json)
      Prismic::Fragments::Text.new(json['value'])
    end

    def self.web_link_parser(json)
      Prismic::Fragments::WebLink.new(json['value']['url'])
    end

    def self.date_parser(json)
    end

    def self.number_parser(json)
      Prismic::Fragments::Number.new(json['value'])
    end

    def self.embed_parser(json)
    end

    def self.image_parser(json)
      def self.view_parser(json)
        Prismic::Fragments::Image::View.new(json['url'],
                                            json['dimensions']['width'],
                                            json['dimensions']['height'])
      end

      main  = view_parser(json['value']['main'])
      views = json['value']['views'].map do |name, view|
        view_parser(view)
      end

      Prismic::Fragments::Image.new(main, views)
    end

    def self.span_parser(json)
    end

    def self.heading_parser(json)
    end

    def self.paragraph_parser(json)
    end

    def self.list_item_parser(json)
    end
  end
end
