require 'net/http'
require 'uri'
require 'yajl'

class ApiData
  attr_accessor :refs, :bookmarks, :types, :tags, :forms
end

class Api
  attr_accessor :refs, :bookmarks, :forms, :master

  def initialize(data)
    @bookmarks = data['bookmarks']
    @refs = get_refs_from_data(data)
    @forms = get_forms_from_data(data)
    @master = get_master_from_data
  end

  def self.get(url, path = '/api')
    http = Net::HTTP.new(URI(url).host)
    req = Net::HTTP::Get.new(path, { 'Accept' => 'application/json' })
    res = http.request(req)

    if res.code == '200'
      res
    else
      raise PrismicWSConnectionError, res.message
    end
  end

  def self.parse_api_response(data)
    parser = Yajl::Parser.new
    result = {}
    hash = parser.parse(data)

    result['bookmarks'] = hash['bookmarks']
    result['types'] = hash['types']
    result['tags'] = hash['tags']

    result['refs'] = hash['refs'].map do |ref|
      Ref.new(ref['ref'], ref['label'], ref['isMasterRef'])
    end

    result
  end

  private
  def get_refs_from_data(data)
    Hash[data['refs'].map { |ref| [ref.label, ref] }]
  end

  def get_forms_from_data(data)
    data['forms'] = data['forms'] || {}
    Hash[
      data['forms'].map do |key, form|
        [key, SearchForm.new(self, form, form.defaultData)]
      end
    ]
  end

  def get_master_from_data
    master = @refs.values
      .map { |ref| ref if ref.isMasterRef }
      .compact
      .first

      if not master.nil?
        master
      else
        raise NoMasterFoundException
      end
  end

  class NoMasterFoundException < Exception
  end

  class PrismicWSConnectionError < Exception
    def initialize(msg)
      super("Can't connect to Prismic's API: #{msg}")
    end
  end
end

class Form
  attr_accessor :name, :method, :rel, :enctype, :action, :fields

  def initialize(name = nil, fields = {})
    @name = name
    @fields = fields
  end

  def defaultData
    fields.select do |k, v|
      not v.nil?
    end
  end
end

class SearchForm
  attr_accessor :api, :form, :data

  def initialize(api, form, data)
    @api = api
    @form = form
    @data = data
  end
end

class Field
  attr_accessor :type, :default
end

class Document
  attr_accessor :id, :type, :href, :tags, :slugs, :fragments
end

class Ref
  attr_accessor :ref, :label, :isMasterRef, :scheduledAt

  def initialize(ref, label, isMasterRef = false)
    @ref = ref
    @label = label
    @isMasterRef = isMasterRef
  end
end
