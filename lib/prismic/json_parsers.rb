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

    def number_parser(json)
    end

    def embed_parser(json)
    end

    def image_parser(json)
    end

    def span_parser(json)
    end

    def heading_parser(json)
    end

    def paragraph_parser(json)
    end

    def list_item_parser(json)
    end
  end
end
