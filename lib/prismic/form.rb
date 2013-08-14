module Prismic
  class Form
    attr_accessor :name, :form_method, :rel, :enctype, :action, :fields

    def initialize(name, fields, form_method, rel, enctype, action)
      @name = name
      @fields = fields
      @form_method = form_method
      @rel = rel
      @enctype = enctype
      @action = action
    end

    def default_data
      fields.select do |k, v|
        not v.nil?
      end
    end
  end
end
