# encoding: utf-8
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

    # Return the full trace of the error (including nested errors)
    # @param [Exception] e Parent error (for internal use)
    #
    # @return [String] The trace
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

  # Return an API instance
  # @api
  #
  # The access token and HTTP client can be provided.
  #
  # The HTTP Client must responds to same method than {DefaultHTTPClient}.
  #
  # @overload api(url)
  #   Simpler syntax (no configuration)
  #   @param [String] url The URL of the prismic.io repository
  # @overload api(url, opts)
  #   Standard use
  #   @param [String] url The URL of the prismic.io repository
  #   @param [Hash] opts The options
  #   @option opts [String] :access_token (nil) The access_token
  #   @option opts :http_client (DefaultHTTPClient) The HTTP client to use
  #   @option opts :cache (nil) The caching object (for instance Prismic::Cache) to use, or false for no caching
  # @overload api(url, access_token)
  #   Provide the access_token (only)
  #   @param [String] url The URL of the prismic.io repository
  #   @param [String] access_token The access token
  #
  # @return [API] The API instance related to this repository
  def self.api(url, opts=nil)
    opts ||= {}
    opts = {access_token: opts} if opts.is_a?(String)
    API.start(url, opts)
  end

  class ApiData
    attr_accessor :refs, :bookmarks, :types, :tags, :forms
  end


  # A SearchForm represent a Form returned by the prismic.io API.
  #
  # These forms depend on the prismic.io repository, and can be filled and sent
  # as regular HTML forms.
  #
  # You may get a SearchForm instance through the {API#form} method.
  #
  # The SearchForm instance contains helper methods for each predefined form's fields.
  # Note that these methods are not created if they risk to add confusion:
  # - only letters, underscore and digits are authorized in the name
  # - name starting with a digit or an underscore are forbidden
  # - generated method can't override existing methods
  #
  # @example
  #   search_form = api.form('everything')
  #   search_form.page(3)  # specify the field 'page'
  #   search_form.page_size("20")  # specify the 'page_size' field
  #   results = search_form.submit(master_ref)  # submit the search form
  #   results = api.form('everything').page(3).page_size("20").submit(master_ref) # methods can be chained
  class SearchForm
    attr_accessor :api, :form, :data, :ref

    def initialize(api, form, data={}, ref=nil)
      @api = api
      @form = form
      @data = {}
      form.fields.each { |name, _| create_field_helper_method(name) }
      form.default_data.each { |key, value| set(key, value) }
      data.each { |key, value| set(key, value) }
      @ref = ref
    end

    # @!method query(query)
    #   Specify a query for this form.
    #   @param  query [String] The query
    #   @return [SearchForm] self

    # @!method orderings(orderings)
    #   Specify a orderings for this form.
    #   @param  orderings [String] The orderings
    #   @return [SearchForm] self

    # @!method page(page)
    #   Specify a page for this form.
    #   @param  page [String,Fixum] The page
    #   @return [SearchForm] self

    # @!method page_size(page_size)
    #   @generated
    #   Specify a page size for this form.
    #   @param  page_size [String,Fixum] The page size
    #   @return [SearchForm] self

    # Create the fields'helper methods
    def create_field_helper_method(name)
      return if name == 'ref'
      return unless name =~ /\A[a-zA-Z][a-zA-Z0-9_]*\z/
      meth_name = name.gsub(/([A-Z])/, '_\1').downcase
      return if respond_to?(meth_name)
      define_singleton_method(meth_name){|value| set(name, value) }
      if name == 'q'
        class << self
          alias :query :q
        end
      end
    end
    private :create_field_helper_method

    def form_name
      form.name
    end

    def form_method
      form.form_method
    end

    def form_rel
      form.rel
    end

    def form_enctype
      form.enctype
    end

    def form_action
      form.action
    end

    def form_fields
      form.fields
    end

    # Submit the form
    # @api
    #
    # @note The reference MUST be defined, either by setting it at
    #       {API#create_search_form creation}, by using the {#ref} method or by
    #       providing the ref parameter.
    #
    # @param  ref [Ref, String] The {Ref reference} to use (if not already defined)
    #
    # @return [Array<Document>] The results
    def submit(ref = nil)
      self.ref(ref) if ref
      raise NoRefSetException unless @ref

      # cache_key is a mix of HTTP URL and HTTP method
      cache_key = form_method+'::'+form_action+'?'+data.map{|k,v|"#{k}=#{v}"}.join('&') if api.has_cache?

      if api.has_cache? && api.cache.include?(cache_key)
        api.cache[cache_key]

      elsif form_method == "GET" && form_enctype == "application/x-www-form-urlencoded"
        data['ref'] = @ref
        data['access_token'] = api.access_token if api.access_token
        data.delete_if { |k, v| v.nil? }

        response = api.http_client.get(form_action, data, 'Accept' => 'application/json')

        if response.code.to_s == "200"
          results = Prismic::JsonParser.results_parser(JSON.parse(response.body))
          api.cache[cache_key] = results if api.has_cache?
          results
        else
          body = JSON.parse(response.body) rescue nil
          error = body.is_a?(Hash) ? body['error'] : response.body
          raise AuthenticationException, error if response.code.to_s == "401"
          raise AuthorizationException, error if response.code.to_s == "403"
          raise RefNotFoundException, error if response.code.to_s == "404"
          raise FormSearchException, error
        end
      else
        raise UnsupportedFormKind, "Unsupported kind of form: #{form_method} / #{enctype}"
      end
    end

    # Specify a parameter for this form
    # @param  field_name [String] The parameter's name
    # @param  value [String] The parameter's value
    #
    # @return [SearchForm] self
    def set(field_name, value)
      field = @form.fields[field_name]
      if field && field.repeatable?
        data[field_name] = [] unless data.include? field_name
        data[field_name] << value
      else
        data[field_name] = value
      end
      self
    end

    # Set the {Ref reference} to use
    # @api
    # @param  ref [Ref, String] The {Ref reference} to use
    #
    # @return [SearchForm] self
    def ref(ref)
      @ref = ref.is_a?(Ref) ? ref.ref : ref
      self
    end

    class NoRefSetException < Error ; end
    class UnsupportedFormKind < Error ; end
    class AuthorizationException < Error ; end
    class AuthenticationException < Error ; end
    class RefNotFoundException < Error ; end
    class FormSearchException < Error ; end
  end

  class Field
    attr_accessor :field_type, :default, :repeatable

    def initialize(field_type, default, repeatable = false)
      @field_type = field_type
      @default = default
      @repeatable = repeatable
    end

    alias :repeatable? :repeatable
  end

  class Document
    attr_accessor :id, :type, :href, :tags, :slugs, :fragments

    def initialize(id, type, href, tags, slugs, fragments)
      @id = id
      @type = type
      @href = href
      @tags = tags
      @slugs = slugs
      @fragments = (fragments.is_a? Hash) ? parse_fragments(fragments) : fragments
    end

    def slug
      slugs.empty? ? '-' : slugs.first
    end

    def as_html(link_resolver)
      fragments.map { |field, fragment|
        %(<section data-field="#{field}">#{fragment.as_html(link_resolver)}</section>)
      }.join("\n")
    end

    # Finds the first highest title in a document
    #
    # It is impossible to reuse the StructuredText.first_title method, since we need to test the highest title across the whole document
    def first_title
      title = false
      max_level = 6 # any title with a higher level kicks the current one out
      @fragments.each do |_, fragment|
        if fragment.is_a? Prismic::Fragments::StructuredText
          fragment.blocks.each do |block|
            if block.is_a?(Prismic::Fragments::StructuredText::Block::Heading)
              if block.level < max_level
                title = block.text
                max_level = block.level # new maximum
              end
            end
          end
        end
      end
      title
    end

    def [](field)
      array = field.split('.')
      raise ArgumentError, "Argument should contain one dot. Example: product.price" if array.length != 2
      return nil if array[0] != self.type
      fragments[array[1]]
    end

    private

    def parse_fragments(fragments)
      fragments
    end
  end


  # Represent a prismic.io reference, a fix point in time.
  #
  # The references must be provided when accessing to any prismic.io resource
  # (except /api) and allow to assert that the URL you use will always
  # returns the same results.
  class Ref
    attr_accessor :ref, :label, :is_master, :scheduled_at

    def initialize(ref, label, is_master = false, scheduled_at = nil)
      @ref = ref
      @label = label
      @is_master = is_master
      @scheduled_at = scheduled_at
    end

    alias :master? :is_master
  end

  class LinkResolver
    attr_reader :ref
    def initialize(ref, &blk)
      @ref = ref
      @blk = blk
    end
    def link_to(doc)
      if doc.is_a? Prismic::Fragments::DocumentLink
        @blk.call(doc)
      elsif doc.is_a? Prismic::Document
        doc_link = Prismic::Fragments::DocumentLink.new(doc.id, doc.type, doc.tags, doc.slug, false)
        @blk.call(doc_link)
      end
    end
  end

  # Default HTTP client implementation, using the standard Net::HTTP library.
  module DefaultHTTPClient
    class << self
      # Performs a GET call and returns the result
      #
      # The result must respond to
      # - code: returns the response's HTTP status code (as number or String)
      # - body: returns the response's body (as String)
      def get(uri, data={}, headers={})
        uri = URI(uri) if uri.is_a?(String)
        uri.query = url_encode(data)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme =~ /https/i
        http.get(uri.request_uri, headers)
      end

      def url_encode(data)
        # Can't use URI.encode_www_form (doesn't support multi-values in 1.9.2)
        encode = ->(k, v){ "#{k}=#{CGI::escape(v)}" }
        data.map { |k, vs|
          if vs.is_a?(Array)
            vs.map{|v| encode.(k, v) }.join("&")
          else
            encode.(k, vs)
          end
        }.join("&")
      end
    end
  end

  # Build a {LinkResolver} instance
  # @api
  #
  # The {LinkResolver} will help to build URL specific to an application, based
  # on a generic prismic.io's {Fragments::DocumentLink Document link}.
  #
  # @param  ref [Ref] The ref to use
  # @yieldparam  doc_link [Fragments::DocumentLink] A DocumentLink instance
  # @yieldreturn [String] The application specific URL of the given document
  #
  # @return [LinkResolver] [description]
  def self.link_resolver(ref, &blk)
    LinkResolver.new(ref, &blk)
  end

end

require 'prismic/api'
require 'prismic/form'
require 'prismic/fragments'
require 'prismic/json_parsers'
require 'prismic/cache'
