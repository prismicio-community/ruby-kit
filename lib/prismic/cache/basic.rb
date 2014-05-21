# encoding: utf-8
module Prismic

  class BasicCacheEntry

    attr_reader :expired_in
    attr_reader :data

    def initialize(data, expired_in = 0)
      @data = data
      @expired_in = expired_in
    end
  end

  class BasicCache

    attr_reader :cache
    attr_reader :expirations

    def initialize(data = {})
      @cache = {}
    end

    def get(key)
      return delete(key) if expired?(key)
      include?(key) ? @cache[key].data : nil
    end

    def set(key, value = nil, expired_in = 0)
      data = block_given? ? yield : value
      expired_in = (expired_in == 0) ? 0 : Time.now.getutc.to_i + expired_in
      entry = BasicCacheEntry.new(data, expired_in)
      @cache[key] = entry
      entry.data
    end

    def include?(key)
      @cache.keys.include?(key)
    end

    def get_or_set(key, value = nil, expired_in = 0)
      return get(key) if include?(key)
      set(key, block_given? ? yield : value, expired_in)
    end

    def delete(key)
      @cache.delete(key)
      nil
    end

    def expired?(key)
      if include?(key)
        expired_in = @cache[key].expired_in
        (expired_in != 0) && expired_in < Time.now.getutc.to_i
      else
        false
      end
    end

    def clear()
      @cache = {}
    end
  end

  DefaultApiCache = BasicCache.new
end
