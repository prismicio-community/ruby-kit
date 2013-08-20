require 'net/http'
require 'uri'
require 'yajl'

module Prismic

  # These exception can contains an error cause and is able to show them
  class Error < Exception
    attr_reader :cause
    def initialize(msg=nil, cause=nil)
      msg, cause = cause, nil if !msg && cause.is_a?(String)
      msg ? super(msg) : msg
      @cause = cause
    end
    def full_trace(e=self)
      first, *backtrace = e.backtrace
      msg = e == self ? "" : "Caused by "
      msg += "#{first}: #{e.message} (#{e.class})"
      stack = backtrace.map{|s| "\tfrom #{s}" }.join("\n")
      cause = e.respond_to?(:cause) ? e.cause : nil
      cause_stack = cause ? full_trace(cause) : nil
      [msg, stack, cause_stack].compact.join("\n")
    end
  end

  class ApiData
    attr_accessor :refs, :bookmarks, :types, :tags, :forms
  end

  class SearchForm
    attr_accessor :api, :form, :data

    def initialize(api, form, data=form.default_data)
      @api = api
      @form = form
      @data = data
    end

    def name
      form.name
    end

    def form_method
      form.form_method
    end

    def rel
      form.rel
    end

    def enctype
      form.enctype
    end

    def action
      form.action
    end

    def fields
      form.fields
    end

  end

  class Field
    attr_accessor :field_type, :default

    def initialize(field_type, default)
      @field_type = field_type
      @default = default
    end

  end

  class Document
    attr_accessor :id, :type, :href, :tags, :slugs, :fragments
  end

  class Ref
    attr_accessor :ref, :label, :master, :scheduledAt

    def initialize(ref, label, master = false)
      @ref = ref
      @label = label
      @master = master
    end

    alias :master? :master

  end

end

require 'prismic/api'
require 'prismic/form'
require 'prismic/fragments'
