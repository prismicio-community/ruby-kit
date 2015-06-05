# encoding: utf-8

require 'hashery'

module Prismic
  # This is a simple cache class provided with the prismic.io Ruby kit.
  #
  # It is pretty dumb but effective: * everything is stored in memory,
  #
  # If you need a smarter caching (for instance, rely on memcached), you can
  # extend this class and replace its methods, and when creating your API object
  # like this for instance: Prismic.api(url, options), pass the name of the
  # class you created as a :cache option. Therefore, to use this simple cache,
  # you can create your API object like this: `Prismic.api(url, cache:
  # Prismic::DefaultCache)`
  class LruCache

    # @return [LRUHash<String,Object>]
    attr_reader :intern

    # @param max_size [Fixnum] (100) The default maximum of keys to store
    def initialize(max_size=100)
      @intern = Hashery::LRUHash.new(max_size)
    end

    # Add a cache entry.
    #
    # @param key [String] The key
    # @param value [Object] The value to store
    #
    # @return [Object] The stored value
    def set(key, value, expired_in = nil)
      @intern.store(key, { :data => value, :expired_in => expired_in = expired_in && Time.now.getutc.to_i + expired_in })
      value
    end

    def []=(key, value)
      set(key, value, nil)
    end

    # Get a cache entry
    #
    # @param key [String] The key to fetch
    #
    # @return [Object] The cache object as was stored
    def get(key)
      return delete(key) if expired?(key)
      include?(key) ? @intern[key][:data] : nil
    end
    alias :[] :get

    def get_or_set(key, value = nil, expired_in = nil)
      if include?(key) && !expired?(key)
        return get(key)
      else
        set(key, block_given? ? yield : value, expired_in)
      end
    end

    def delete(key)
      @intern.delete(key)
      nil
    end

    # Checks if a cache entry exists
    #
    # @param key [String] The key to test
    #
    # @return [Boolean]
    def has_key?(key)
      @intern.has_key?(key)
    end
    alias :include? :has_key?

    def expired?(key)
      if include?(key) && @intern[key][:expired_in] != nil
        expired_in = @intern[key][:expired_in]
        expired_in && expired_in < Time.now.getutc.to_i
      else
        false
      end
    end

    # Invalidates all entries
    def invalidate_all!
      @intern.clear
    end
    alias :clear! :invalidate_all!

    # Expose the Hash keys
    #
    # This is only for debugging purposes.
    #
    # @return [Array<String>]
    def keys
      @intern.keys
    end

    # Return the number of stored keys
    #
    # @return [Fixum]
    def size
      @intern.size
    end
    alias :length :size

  end

  # Available as an api cache for testing purposes (no caching)
  class BasicNullCache
    def get(key)
    end

    def set(key, value = nil, expired_in = nil)
      block_given? ? yield : value
    end
    alias_method :get_or_set, :set

  end

  # This default instance is used by the API to avoid creating a new instance
  # per request (which would make the cache useless).
  DefaultCache = LruCache.new
end
