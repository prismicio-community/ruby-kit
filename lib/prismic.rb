class ApiData
  attr_accessor :refs, :bookmarks, :types, :tags, :forms

  def initialize(data)
    @bookmarks = data['bookmarks']
    @refs = get_refs_from_data(data)
  end

  private
  def get_refs_from_data(data)
    Hash[data['refs'].map { |ref| [ref.label, ref] }]
  end
end

class Form
  attr_accessor :name, :method, :rel, :enctype, :action, :fields

  def defaultData
    fields.select do |k, v|
      not v.nil?
    end
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

  def initialize(ref, label)
    @ref = ref
    @label = label
  end
end
