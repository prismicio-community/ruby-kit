module Prismic
  module JsonParser
    def self.document_link_parser(json)
      Prismic::Fragments::DocumentLink.new(
        json['document']['id'],
        json['document']['type'],
        json['document']['tags'],
        json['document']['slug'],
        json['isBroken'])
    end

    def text_parser(json)
    end

    def web_link_parser(json)
    end

    def date_parser(json)
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
