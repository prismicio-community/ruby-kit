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

  private
  def get_refs_from_data(data)
    Hash[data['refs'].map { |ref| [ref.label, ref] }]
  end

  def get_forms_from_data(data)
    Hash[
      data['forms'].map do |key, form|
        [key, SearchForm.new(self, form, form.defaultData)]
      end
    ]
  end

  def get_master_from_data
    @refs.values
      .map { |ref| ref if ref.isMasterRef }
      .compact
      .first
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
