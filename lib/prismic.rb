class ApiData
  attr_accessor :refs, :bookmarks, :types, :tags, :forms

  def parse_json(json)
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
end
