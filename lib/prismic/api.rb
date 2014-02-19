# encoding: utf-8

module Prismic
  class API
    @@cache = nil
    @@warned_create_search_form = false
    attr_reader :json, :access_token, :http_client
    attr_accessor :refs, :bookmarks, :forms, :tags, :types, :oauth

    # Is the cache enabled on this API object?
    #
    # @return [Boolean]
    attr_accessor :cached

    # An alias to know if the cache is enabled on this API object
    def cached?
      @cached
    end

    # Returns the master {Ref reference}
    # @api
    #
    # @return [Ref] The master {Ref reference}
    attr_accessor :master
    alias :master_ref :master

    def initialize(json, access_token, http_client, cache_class=false)
      @json = json
      @access_token = access_token
      @http_client = http_client
      yield self if block_given?
      @cached = !!cache_class
      @@cache ||= cache_class.new if cached?
      self.master = refs.values && refs.values.map { |ref| ref if ref.master? }.compact.first
      raise BadPrismicResponseError, "No master Ref found" unless master
    end

    # Exposing the class variable as an instance method, so we don't need to require Prismic::API to have it work from an API object.
    def cache
      @@cache
    end

    # Get a bookmark by its name
    # @api
    # @param  name [String] The bookmark's name
    #
    # @return [Hash] The bookmark
    def bookmark(name)
      bookmarks[name]
    end

    # Get a {Ref reference} by its alias
    # @api
    # @param  name [String] The reference's alias
    #
    # @return [Ref] The reference
    def ref(name)
      refs[name.downcase]
    end

    # Returns a {Prismic::SearchForm search form} by its name
    # @api
    # @param  name [String] The name of the form
    # @param  data [Hash] Default values
    # @param  ref [type] Default {Ref reference}
    #
    # @return [SearchForm] The search form
    def form(name, data={}, ref={})
      form = self.forms[name]
      form and form.create_search_form(data, ref)
    end

    # @deprecated Use {#form} instead.
    def create_search_form(name, data={}, ref={})
      if !@@warned_create_search_form
        warn "[DEPRECATION] `create_search_form` is deprecated.  Please use `form` instead."
        @@warned_create_search_form = true
      end
      form(name, data, ref)
    end

    def as_json
      @json
    end

    def self.get(url, access_token=nil, http_client=Prismic::DefaultHTTPClient)
      data = {}
      data["access_token"] = access_token if access_token
      res = http_client.get(url, data, 'Accept' => 'application/json')
      raise PrismicWSConnectionError, res unless res.code.to_s == '200'
      res
    end

    def self.start(url, opts={})
      http_client = opts[:http_client] || Prismic::DefaultHTTPClient
      access_token = opts[:access_token]
      cache_class = opts[:cache_class] || false
      resp = get(url, access_token, http_client)
      json = JSON.load(resp.body)
      parse_api_response(json, access_token, http_client, cache_class)
    end

    def self.parse_api_response(data, access_token, http_client, cache_class=false)
      data_forms = data['forms'] || []
      data_refs = data.fetch('refs'){ raise BadPrismicResponseError, "No refs given" }
      new(data, access_token, http_client, cache_class) {|api|
        api.bookmarks = data['bookmarks']
        api.forms = Hash[data_forms.map { |k, form|
          [k, Form.new(
            api,
            form['name'],
            Hash[form['fields'].map { |k2, field|
              [k2, Field.new(field['type'], field['default'], k2 == 'q')]
            }],
            form['method'],
            form['rel'],
            form['enctype'],
            form['action'],
          )]
        }]
        api.refs = Hash[data_refs.map { |ref|
          scheduled_at = ref['scheduledAt']
          [ref['label'].downcase, Ref.new(ref['ref'], ref['label'], ref['isMasterRef'], scheduled_at && Time.at(scheduled_at / 1000.0))]
        }]
        api.tags = data['tags']
        api.types = data['types']
        api.oauth = OAuth.new(data['oauth_initiate'], data['oauth_token'])
      }
    end

    def oauth_initiate_url(opts)
      oauth.initiate + "?" + {
        "client_id" => opts.fetch(:client_id),
        "redirect_uri" => opts.fetch(:redirect_uri),
        "scope" => opts.fetch(:scope),
      }.map{|kv| kv.map{|e| CGI.escape(e) }.join("=") }.join("&")
    end

    def oauth_check_token(params)
      uri = URI(oauth.token)
      res = Net::HTTP.post_form(uri, params)
      if res.code == '200'
        begin
          JSON.parse(res.body)['access_token']
        rescue Exception => e
          raise PrismicWSConnectionError.new(res, e)
        end
      else
        raise PrismicWSConnectionError, res
      end
    end

    private

    class BadPrismicResponseError < Error ; end

    class PrismicWSConnectionError < Error
      def initialize(resp, cause=nil)
        super("Can't connect to Prismic's API: #{resp.code} #{resp.message}", cause)
      end
    end

    class OAuth
      attr_reader :initiate, :token
      def initialize(initiate, token)
        @initiate = initiate
        @token = token
      end
    end
  end
end
