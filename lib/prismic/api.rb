module Prismic
  class API
    attr_accessor :refs, :bookmarks, :forms, :master, :tags, :types

    def initialize(json)
      @json = json
      @bookmarks = {}
      @refs = {}
      @forms = {}
      @master = nil
      @tags = {}
      @types = {}
      yield self
    end

    def bookmark(name)
      bookmarks[name]
    end

    def ref(name)
      refs[name]
    end

    def ref_id_by_label(label)
      refs.find { |k, ref| k == label }.last
    end

    def form(name)
      forms[name]
    end

    def as_json
      @json
    end

    def self.get(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host)
      req = Net::HTTP::Get.new(uri.path, {'Accept' => 'application/json'})
      res = http.request(req)

      if res.code == '200'
        res
      else
        raise PrismicWSConnectionError, res
      end
    end

    def self.start(url)
      resp = get(url)
      json = JSON.load(resp.body)
      parse_api_response(json)
    end

    def self.parse_api_response(data)
      new(data) { |api|
        api.bookmarks = data['bookmarks']
        data_forms = data['forms'] || []
        api.forms = Hash[data_forms.map { |k, form|
          [k, SearchForm.new(api, Form.new(
            form['name'],
            Hash[form['fields'].map { |k2, field|
              [k2, Field.new(field['type'], field['default'])]
            }],
            form['method'],
            form['rel'],
            form['enctype'],
            form['action'],
          ))]
        }]
        data_refs = data.fetch('refs'){ raise BadPrismicResponseError, "No refs given" }
        api.refs = Hash[data_refs.map { |ref|
          [ref['label'], Ref.new(ref['ref'], ref['label'], ref['isMasterRef'])]
        }]
        api.master = api.refs.values.map { |ref| ref if ref.master? }.compact.first
        raise BadPrismicResponseError, "No master Ref found" unless api.master
        api.tags = data['tags']
        api.types = data['types']
      }
    end

    private

    class BadPrismicResponseError < Error ; end

    class PrismicWSConnectionError < Error
      def initialize(resp, cause=nil)
        super("Can't connect to Prismic's API: #{resp.code} #{resp.message}", cause)
      end
    end
  end
end
