# encoding: utf-8

module Prismic
  # The API is the main class
  class API
    @@warned_create_search_form = false
    @@warned_oauth_initiate_url = false
    @@warned_oauth_check_token = false
    attr_reader :json
    # @return [String]
    attr_reader :access_token
    attr_reader :http_client
    # @return [Hash{String => Ref}] list of references, as label -> reference
    attr_accessor :refs
    # @return [Hash{String => String}] list of bookmarks, as name -> documentId
    attr_accessor :bookmarks
    # @return [Hash{String => SearchForm}] list of bookmarks, as name -> documentId
    attr_accessor :forms
    attr_accessor :tags, :types, :oauth, :cache
    # @return [Experiments] list of all experiments from Prismic
    attr_accessor :experiments

    # Is the cache enabled on this API object?
    #
    # @return [Boolean]
    def has_cache?
      !!cache
    end

    # Calls the given block if the provided key is not already cached
    #
    # If the cache is disabled, the block is always called
    #
    # @param key [String] the cache's key to test
    # @yieldparam key [String] the key
    #
    # @return the return of the given block
    def caching(key)
      cache ? cache.get(key){ yield(key) } : yield(key)
    end

    # Returns the master {Ref reference}
    # @api
    #
    # @return [Ref] The master {Ref reference}
    attr_accessor :master
    alias :master_ref :master

    def initialize(json, access_token, http_client, cache)
      @json = json
      @access_token = access_token
      @http_client = http_client
      yield self if block_given?
      @cache = cache
      self.master = refs.values && refs.values.map { |ref| ref if ref.master? }.compact.first
      raise BadPrismicResponseError, 'No master Ref found' unless master
    end

    # Get a bookmark by its name
    # @api
    # @param [String] The bookmark's name
    #
    # @return [String] The bookmark document id
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

    # Returns a {Prismic::SearchForm search form} by its name. This is where you start to query a repository.
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
      unless @@warned_create_search_form
        warn '[DEPRECATION] `create_search_form` is deprecated.  Please use `form` instead.'
        @@warned_create_search_form = true
      end
      form(name, data, ref)
    end

    # Return the URL to display a given preview
    # @param token [String] as received from Prismic server to identify the content to preview
    # @param link_resolver the link resolver to build URL for your site
    # @param default_url [String] the URL to default to return if the preview doesn't correspond to a document
    # (usually the home page of your site)
    #
    # @return [String] the URL to redirect the user to
    def preview_session(token, link_resolver, default_url)
      response = self.http_client.get(token, {}, 'Accept' => 'application/json')
      if response.code.to_s != '200'
        return default_url
      end
      json = JSON.load(response.body)
      documents = self.form('everything').query(Prismic::Predicates.at('document.id', json['mainDocument'])).submit(token)
      if documents.results.size > 0
        link_resolver.link_to(documents.results[0])
      else
        default_url
      end
    end

    def as_json
      @json
    end

    # Fetch the API information from the Prismic.io server
    def self.get(url, access_token=nil, http_client=Prismic::DefaultHTTPClient, api_cache=Prismic::DefaultApiCache)
      data = {}
      data['access_token'] = access_token if access_token
      cache_key = url + (access_token ? ('#' + access_token) : '')
      api_cache.get_or_set(cache_key, nil, 5) {
        res = http_client.get(url, data, 'Accept' => 'application/json')
        case res.code
        when '200'
          res
        when '401', '403'
          begin
            json = JSON.load(res.body)
            raise PrismicWSAuthError.new(
              json['error'],
              json['oauth_initiate'],
              json['oauth_token'],
              http_client
            )
          rescue => e
            raise PrismicWSConnectionError.new(res, e)
          end
        else
          raise PrismicWSConnectionError, res
        end
      }
    end

    def self.start(url, opts={})
      http_client = opts[:http_client] || Prismic::DefaultHTTPClient
      access_token = opts[:access_token]
      cache = opts[:cache]
      api_cache = opts[:api_cache]
      api_cache = Prismic::DefaultApiCache unless api_cache
      cache ||= Prismic::DefaultCache unless !cache
      resp = get(url, access_token, http_client, api_cache)
      json = JSON.load(resp.body)
      parse_api_response(json, access_token, http_client, cache)
    end

    def self.parse_api_response(data, access_token, http_client, cache)
      data_forms = data['forms'] || []
      data_refs = data.fetch('refs'){ raise BadPrismicResponseError, "No refs given" }
      new(data, access_token, http_client, cache) {|api|
        api.bookmarks = data['bookmarks']
        api.forms = Hash[data_forms.map { |k, form|
          [k, Form.from_json(api, form)]
        }]
        api.refs = Hash[data_refs.map { |ref|
          scheduled_at = ref['scheduledAt']
          [ref['label'].downcase, Ref.new(ref['id'], ref['ref'], ref['label'], ref['isMasterRef'], scheduled_at && Time.at(scheduled_at / 1000.0))]
        }]
        api.tags = data['tags']
        api.types = data['types']
        api.oauth = OAuth.new(data['oauth_initiate'], data['oauth_token'], http_client)
        api.experiments = Experiments.parse(data['experiments'])
      }
    end

    def self.oauth_initiate_url(url, oauth_opts, api_opts={})
      oauth =
          begin
            api = self.start(url, api_opts)
            api.oauth
          rescue PrismicWSAuthError => e
            e.oauth
          end
      oauth.initiate_url(oauth_opts)
    end

    def oauth_initiate_url(opts)
      if !@@warned_oauth_initiate_url
        warn "[DEPRECATION] Method `API#oauth_initiate_url` is deprecated.  " +
          "Please use `Prismic::API.oauth_initiate_url` instead."
        @@warned_oauth_initiate_url = true
      end
      oauth.initiate_url(opts)
    end

    def self.oauth_check_token(url, oauth_params, api_opts={})
      oauth =
          begin
            api = self.start(url, api_opts)
            api.oauth
          rescue PrismicWSAuthError => e
            e.oauth
          end
      oauth.check_token(oauth_params)
    end

    def oauth_check_token(params)
      unless @@warned_oauth_check_token
        warn "[DEPRECATION] Method `API#oauth_check_token` is deprecated.  " +
                 "Please use `Prismic::API.oauth_check_token` instead."
        @@warned_oauth_check_token = true
      end
      oauth.check_token(params)
    end

    private

    class BadPrismicResponseError < Error ; end

    class PrismicWSConnectionError < Error
      def initialize(resp, cause=nil)
        super("Can't connect to Prismic's API: #{resp.code} #{resp.message}", cause)
      end
    end

    class PrismicWSAuthError < Error
      attr_reader :error, :oauth
      def initialize(error, oauth_initialize, oauth_token, http_client)
        super("Can't connect to Prismic's API: #{error}")
        @error = error
        @oauth = OAuth.new(oauth_initialize, oauth_token, http_client)
      end
    end

    class OAuth
      attr_reader :initiate, :token, :http_client
      def initialize(initiate, token, http_client)
        @http_client = http_client
        @initiate = initiate
        @token = token
      end
      def initiate_url(opts)
        initiate + '?' + {
          'client_id' => opts.fetch(:client_id),
          'redirect_uri' => opts.fetch(:redirect_uri),
          'scope' => opts.fetch(:scope),
        }.map{|kv| kv.map{|e| CGI.escape(e) }.join('=') }.join('&')
      end
      def check_token(params)
        res = http_client.post(token, params)
        if res.code == '200'
          begin
            JSON.load(res.body)['access_token']
          rescue Exception => e
            raise PrismicWSConnectionError.new(res, e)
          end
        else
          raise PrismicWSConnectionError, res
        end
      end
    end

  end
end
