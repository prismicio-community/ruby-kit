# encoding: utf-8

require 'uri'

module Prismic
  module JsonParser
    class << self
      @@warned_unknown_type = []
      def parsers
        @parsers ||= {
          'Link.document'  => method(:document_link_parser),
          'Text'           => method(:text_parser),
          'Link.web'       => method(:web_link_parser),
          'Link.image'     => method(:image_link_parser),
          'Link.file'      => method(:file_link_parser),
          'Date'           => method(:date_parser),
          'Timestamp'      => method(:timestamp_parser),
          'Number'         => method(:number_parser),
          'Embed'          => method(:embed_parser),
          'GeoPoint'       => method(:geo_point_parser),
          'Image'          => method(:image_parser),
          'Color'          => method(:color_parser),
          'StructuredText' => method(:structured_text_parser),
          'Select'         => method(:select_parser),
          'Multiple'       => method(:multiple_parser),
          'Group'          => method(:group_parser),
          'SliceZone'      => method(:slices_parser),
          'Separator'      => method(:separator_parser)
        }
      end

      def document_link_parser(json)
        doc = json['value']['document']
        type = doc['type']
        fragments = {}
        if doc['data'] and doc['data'][type]
          fragments = Hash[doc['data'][type].map { |name, fragment|
            if fragment.is_a? Array
              [name, multiple_parser(fragment)]
            else
              [name, parsers[fragment['type']].call(fragment)]
            end
          }]
        end
        Prismic::Fragments::DocumentLink.new(
          doc['id'],
          doc['uid'],
          type,
          doc['tags'],
          URI.unescape(doc['slug']),
          doc['lang'],
          fragments,
          json['value']['isBroken'],
          json['value']['target'] ? json['value']['target'] : nil)
      end

      def image_link_parser(json)
        Prismic::Fragments::ImageLink.new(
          json['value']['image']['url'],
          json['value']['target'] ? json['value']['target'] : nil)
      end

      def file_link_parser(json)
        Prismic::Fragments::FileLink.new(
          json['value']['file']['url'],
          json['value']['file']['name'],
          json['value']['file']['kind'],
          json['value']['file']['size'],
          json['value']['target'] ? json['value']['target'] : nil )
      end

      def text_parser(json)
        Prismic::Fragments::Text.new(json['value'])
      end

      def separator_parser(json)
        Prismic::Fragments::Separator.new('')
      end

      def select_parser(json)
        Prismic::Fragments::Text.new(json['value'])
      end

      def web_link_parser(json)
        Prismic::Fragments::WebLink.new(json['value']['url'], json['value']['target'])
      end

      def date_parser(json)
        Prismic::Fragments::Date.new(Time.parse(json['value']))
      end

      def timestamp_parser(json)
        Prismic::Fragments::Timestamp.new(Time.parse(json['value']))
      end

      def number_parser(json)
        Prismic::Fragments::Number.new(json['value'])
      end

      def embed_parser(json)
        oembed = json['value']['oembed']
        Prismic::Fragments::Embed.new(
          oembed['type'],
          oembed['provider_name'],
          oembed['provider_url'],
          oembed['html'],
          oembed
        )
      end

      def geo_point_parser(json)
        Prismic::Fragments::GeoPoint.new(
          json['value']['longitude'],
          json['value']['latitude']
        )
      end

      def image_parser(json)
        main  = view_parser(json['value']['main'])
        views = {}
        json['value']['views'].each do |name, view|
          views[name] = view_parser(view)
        end

        Prismic::Fragments::Image.new(main, views)
      end

      def color_parser(json)
        Prismic::Fragments::Color.new(json['value'][1..6])
      end

      def structured_text_parser(json)
        def self.span_parser(span)
          case span['type']
          when 'em'
            Prismic::Fragments::StructuredText::Span::Em.new(span['start'], span['end'])
          when 'strong'
            Prismic::Fragments::StructuredText::Span::Strong.new(span['start'], span['end'])
          when 'hyperlink'
            Prismic::Fragments::StructuredText::Span::Hyperlink.new(span['start'], span['end'], link_parser(span['data']))
          else
            label = span['data'] && span['data']['label']
            Prismic::Fragments::StructuredText::Span::Label.new(span['start'], span['end'], label)
          end
        end

        blocks = json['value'].map do |block|
          case block['type']
          when 'paragraph'
            spans = block['spans'].map {|span| span_parser(span) }
            Prismic::Fragments::StructuredText::Block::Paragraph.new(block['text'], spans, block['label'])
          when 'preformatted'
            spans = block['spans'].map {|span| span_parser(span) }
            Prismic::Fragments::StructuredText::Block::Preformatted.new(block['text'], spans, block['label'])
          when /^heading(\d+)$/
            heading = $1
            spans = block['spans'].map {|span| span_parser(span) }
            Prismic::Fragments::StructuredText::Block::Heading.new(
              block['text'],
              spans,
              heading.to_i,
              block['label']
            )
          when 'o-list-item'
            spans = block['spans'].map {|span| span_parser(span) }
            Prismic::Fragments::StructuredText::Block::ListItem.new(
              block['text'],
              spans,
              true,  # ordered
              block['label']
            )
          when 'list-item'
            spans = block['spans'].map {|span| span_parser(span) }
            Prismic::Fragments::StructuredText::Block::ListItem.new(
              block['text'],
              spans,
              false,  # unordered
              block['label']
            )
          when 'image'
            Prismic::Fragments::StructuredText::Block::Image.new(
                view_parser(block),
                block['label']
            )
          when 'embed'
            boembed = block['oembed']
            Prismic::Fragments::Embed.new(
              boembed['type'],
              boembed['provider_name'],
              boembed['provider_url'],
              boembed['html'],
              boembed
            )
          else
            puts "Unknown bloc type: #{block['type']}"
          end
        end
        Prismic::Fragments::StructuredText.new(blocks)
      end

      def multiple_parser(json)
        fragments = json.map do |fragment|
          parsers[fragment['type']].call(fragment)
        end
        Prismic::Fragments::Multiple.new(fragments)
      end

      def group_parser(json)
        fragment_list_array = []
        json['value'].each do |group|
          fragments = Hash[ group.map {|name, fragment| [name, parsers[fragment['type']].call(fragment)] }]
          fragment_list_array << Prismic::Fragments::GroupDocument.new(fragments)
        end
        Prismic::Fragments::Group.new(fragment_list_array)
      end

      def slices_parser(json)
        slices = []

        json['value'].each do |data|
          slice_type = data['slice_type']
          slice_label = data['slice_label']

          if data.key?('value')
            slices << Prismic::Fragments::SimpleSlice.new(slice_type, slice_label, fragment_parser(data['value']))
          else
            non_repeat = {}
            data['non-repeat'].each do |fragment_key, fragment_value|
              non_repeat[fragment_key] = fragment_parser(fragment_value)
            end

            repeat = group_parser({ 'type' => 'Group', 'value' => data['repeat']})

            slices << Prismic::Fragments::CompositeSlice.new(slice_type, slice_label, non_repeat, repeat)            
          end
        end
        Prismic::Fragments::SliceZone.new(slices)
      end

      def fragment_parser(fragment)
        if fragment.is_a? Array
          multiple_parser(fragment)
        else
          parsers[fragment['type']].call(fragment)
        end
      end

      def alternate_language_parser(alternate_language)
        Prismic::AlternateLanguage.new(alternate_language) 
      end

      def document_parser(json)
        data_json = json['data'].values.first  # {"doc_type": data}

        # Removing the unknown types + sending a warning, once
        data_json.select!{ |_, fragment|
          known_type = fragment.is_a?(Array) || parsers.include?(fragment['type'])
          if !known_type && !@@warned_unknown_type.include?(fragment['type'])
            warn "Type #{fragment['type']} is unknown, fragment was skipped; perhaps you should update your prismic.io gem?"
            @@warned_unknown_type << fragment['type']
          end
          known_type
        }

        alternate_languages = nil
        if json.key?('alternate_languages')
          alternate_languages = Hash[json['alternate_languages'].map { |doc| 
            [doc['lang'], alternate_language_parser(doc)]
          }]
        end

        fragments = Hash[data_json.map { |name, fragment|
          [name, fragment_parser(fragment)]
        }]

        Prismic::Document.new(
            json['id'],
            json['uid'],
            json['type'],
            json['href'],
            json['tags'],
            json['slugs'].map { |slug| URI.unescape(slug) },
            json['first_publication_date'] && Time.parse(json['first_publication_date']),
            json['last_publication_date'] && Time.parse(json['last_publication_date']),
            json['lang'],
            alternate_languages,
            fragments)
      end

      def results_parser(results)
        results.map do |doc|
          document_parser(doc)
        end
      end

      def response_parser(documents)
        raise FormSearchException, "Error : #{documents['error']}" if documents['error']
        Prismic::Response.new(
          documents['page'],
          documents['results_per_page'],
          documents['results_size'],
          documents['total_results_size'],
          documents['total_pages'],
          documents['next_page'],
          documents['prev_page'],
          results_parser(documents['results'])
        )
      end

      private

      def view_parser(json)
        Prismic::Fragments::Image::View.new(json['url'],
                                            json['dimensions']['width'],
                                            json['dimensions']['height'],
                                            json['alt'],
                                            json['copyright'],
                                            json['linkTo'] ? link_parser(json['linkTo']) : nil)
      end

      def linked_documents_parser(json)
        if json
          json.map! do |linked_doc|
            LinkedDocument.new(linked_doc['id'], linked_doc['slug'], linked_doc['type'], linked_doc['tags'])
          end
        else
          []
        end
      end

      def link_parser(json)
        if json['type'] == 'Link.document'
          document_link_parser(json)
        elsif json['type'] == 'Link.web'
          web_link_parser(json)
        elsif json['type'] == 'Link.image'
          image_link_parser(json)
        elsif json['type'] == 'Link.file'
          file_link_parser(json)
        end
      end
    end
  end
end
