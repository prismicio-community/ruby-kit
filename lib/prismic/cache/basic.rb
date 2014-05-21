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
      assert_valid_key!(key)
      return unset(key) if expired?(key)
      set?(key) ? @cache[key].data : nil
    end

    def set(key, value = nil, expired_in = 0)
      assert_valid_key!(key)
      data = block_given? ? yield : value
      expired_in = (expired_in == 0) ? 0 : Time.now.getutc.to_i + expired_in
      entry = BasicCacheEntry.new(data, expired_in)
      @cache[key] = entry
      entry.data
    end

    def set?(key)
      assert_valid_key!(key)
      @cache.keys.include?(key)
    end

    def get_or_set(key, value = nil, expired_in = 0)
      assert_valid_key!(key)
      return get(key) if set?(key)
      set(key, block_given? ? yield : value, expired_in)
    end

    def unset(key)
      assert_valid_key!(key)
      @cache.delete(key)
      nil
    end

    def expired?(key)
      assert_valid_key!(key)
      if set?(key)
        expired_in = @cache[key].expired_in
        (expired_in != 0) && expired_in < Time.now.getutc.to_i if set?(key)
      else
        false
      end
    end

    def clear()
      @cache = {}
    end

    def assert_valid_key!(key)
      unless key.is_a?(String)
        raise TypeError, "key must be a String"
      end
    end
  end
end
