# encoding: utf-8
module Prismic
  class Form
    attr_accessor :name, :form_method, :rel, :enctype, :action, :fields

    def initialize(api, name, fields, form_method, rel, enctype, action)
      @api = api
      @name = name
      @fields = fields
      @form_method = form_method
      @rel = rel
      @enctype = enctype
      @action = action
    end

    def default_data
      Hash[fields.map{|key, field| [key, field.default] if field.default }.compact]
    end

    def create_search_form(data={}, ref=nil)
      SearchForm.new(@api, self, data, ref)
    end

    def self.from_json(api, json)
      Form.new(
          api,
          json['name'],
          Hash[json['fields'].map { |k2, field|
            [k2, Field.new(field['type'], field['default'], k2 == 'q')]
          }],
          json['method'],
          json['rel'],
          json['enctype'],
          json['action']
      )
    end

  end
end
