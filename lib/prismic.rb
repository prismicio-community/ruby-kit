require 'net/http'
require 'uri'

module Prismic

  # These exception can contains an error cause and is able to show them
  class Error < Exception
    attr_reader :cause
    def initialize(msg=nil, cause=nil)
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
  class MissingRef < Error
    def initialize(msg=nil, cause=nil)
      super(msg || "Can't use the API without specifying a ref to use", cause)
    end
  end

  def self.api(*args)
    API.start(*args)
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

    attr_accessor :ref
    def ref(given_ref=nil)
      if given_ref
        self.ref = given_ref
      else
        @ref
      end
    end

    def submit(given_ref=nil)
      ref = ref(given_ref)
      raise MissingRef unless ref
      if form_method == "GET" && enctype == "application/x-www-form-urlencoded"
        uri = URI(action)
        uri.query = URI.encode_www_form(data)
        Net::HTTP.get_response(uri).value
      else
        raise UnsupportedFormKind, "Unsupported kind of form: #{form_method} / #{enctype}"
      end
    end

    class UnsupportedFormKind < Error ; end

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
