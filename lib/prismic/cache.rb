# encoding: utf-8
module Prismic
  # This is a simple cache class provided with the prismic.io Ruby kit.
  # It is pretty dumb but effective:
  #  * everything is stored in memory,
  #  * invalidation: not needed for prismic.io documents (they are eternally immutable), but we don't want the cache to expand indefinitely; therefore all cache but the new master ref is cleared when a new master ref gets published.
  #
  # If you need a smarter caching (for instance, caching in files), you can extend this class and replace its methods,
  # and when creating your API object like this for instance: Prismic.api(url, options), pass the name of the class you created
  # as a :cache_class option.
  # Therefore, to use this simple cache, you can create your API object like this: Prismic.api(url, {cache_class: Prismic::Cache})
  class Cache

    # Returns the cache object holding the responses to "results" queries (lists of documents).
    # This is a Hash in a Hash: keys in the outer Hash are the refs (so that it's easy to invalidate entire refs at once);
    # keys in the inner Hash are the query strings (URLs) of each query.
    # The object that is stored as a cache_object is what is returned by Prismic::JsonParser::results_parser
    # (so that we don't have to parse anything again, it's stored already parsed).
    # 
    # @api
    #
    # @return [Hash[Hash[Object]]]
    attr_accessor :resultscache

    attr_accessor :latest_known_master_ref

    # Initialize the data structures
    def initialize
      @resultscache = {} # Each non-existing value is an empty Hash by default
    end

    # Add a cache entry.
    def add(ref_id, cache_key, cache_object, api)
      # if new master ref for this api, invalidate all other cache
      if (@latest_known_master_ref != api.master.ref)
        invalidate_all_but!(api.master.ref)
        @latest_known_master_ref = api.master.ref
      end
      # and now, add
      @resultscache[ref_id] ||= {}
      @resultscache[ref_id][cache_key] = cache_object
    end

    # Get a cache entry
    #
    # @return [Object] the cache object as was stored
    def get(ref_id, cache_key)
      @resultscache[ref_id][cache_key]
    end

    # Checks if a cache entry exists
    #
    # @return [Boolean]
    def contains?(ref_id, cache_key)
      @resultscache.key?(ref_id) && @resultscache[ref_id].key?(cache_key)
    end

    # Invalidates all the cache
    def invalidate_all!
      @resultscache.clear
    end

    # Invalidates all the cache but one ref (happens when new master ref)
    def invalidate_all_but!(ref_id)
      @resultscache.delete_if { |key, _| key != ref_id }
    end

    # Expose a Hash of the keys of both Hashes. The keys of this Hash is the ref_ids, the values are arrays of cache_keys.
    # This is only for displaying purposes, if you want to check out what's stored in your cache without checking out the
    # quite verbose cache_objects.
    #
    # @return [Hash[Array[String]]]
    def all_keys
      Hash[ @resultscache.map{ |k, v| [k, v.keys] } ]
    end
  end
end
