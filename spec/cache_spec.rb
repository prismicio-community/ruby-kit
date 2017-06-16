# encoding: utf-8
require 'spec_helper'

describe "Cache's" do

  describe 'on/off switch' do
    before do
      @api = Prismic.api("https://micro.prismic.io/api", cache: Prismic::LruCache.new(3))
      @cache = @api.cache
      @master_ref = @api.master
    end

    it "is properly on" do
      expect(@api.has_cache?).to be(true)
      expect(@cache.is_a?(Prismic::LruCache)).to be(true)
    end

    it "is properly off" do
      api = Prismic.api("https://micro.prismic.io/api", cache: nil)
      expect(api.has_cache?).to be(false)
    end

    describe 'storage and retrieval' do
      it 'stores properly' do
        expect(@cache.intern.size).to eq(0)
        @api.form('arguments').submit(@master_ref)
        expect(@cache.intern.size).to eq(1)
      end

      it 'does not cache /api' do
        # do not call anything, so the only request made is the /api one
        expect(@cache.intern.size).to eq(0)
      end
    end

    describe 'cache storage' do
      before do
        # max_size = 3
        @cache['fake_key1'] = 1
        @cache['fake_key2'] = 2
        @cache['fake_key3'] = 3
      end
      it 'contains some keys' do
        expect(@cache.include?('fake_key1')).to be(true)
      end
      it 'contains all keys' do
        expect(@cache.intern.size).to eq(3)
      end
      it 'can return all keys' do
        expect(@cache.keys).to eq(%w(fake_key1 fake_key2 fake_key3))
      end
      it 'keeps readed keys alive' do
        @cache['fake_key1']
        @cache['fake_key4'] = 4
        expect(@cache.include?('fake_key1')).to be(true)
        expect(@cache.include?('fake_key2')).to be(false)
      end
    end

    describe 'caching on a real repository' do
      before do
        @api = Prismic.api("https://micro.prismic.io/api", access_token: 'MC5VcXBHWHdFQUFONDZrbWp4.77-9cDx6C3lgJu-_vXZafO-_vXPvv73vv73vv70777-9Ju-_ve-_vSLvv73vv73vv73vv70O77-977-9Me-_vQ')
        @cache = @api.cache
        @master_ref = @api.master_ref
        @other_ref = @api.refs['adding jason']
      end
      it 'works on different refs' do
        expect(@api.form('everything').submit(@master_ref).total_results_size).to eq(24)
        expect(@api.form('everything').submit(@other_ref).total_results_size).to eq(25)
      end
    end
  end

  describe 'configurable api cache' do
    let(:api_cache) { Prismic::BasicNullCache.new }
    it 'uses api_cache if provided' do
      expect(api_cache).to receive(:get_or_set).with("https://micro.prismic.io/api", nil, 5).and_call_original.once
      Prismic.api("https://micro.prismic.io/api", api_cache: api_cache)
    end
    it 'uses default cache if not provided' do
      expect(Prismic::DefaultCache).to receive(:get_or_set).with("https://micro.prismic.io/api", nil, 5).and_call_original.once
      Prismic.api("https://micro.prismic.io/api")
    end
  end
end

describe "LRU Cache's" do

  it 'set & get value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    expect(cache.get('key')).to eq('value')
  end

  it 'set with expiration value & get value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value', 1)
    sleep(2)
    expect(cache.get('key')).to be(nil)
  end

  it 'set with expiration and a block' do
    cache = Prismic::LruCache.new
    cache.get_or_set('key', nil, 1){ 'value' }
    expect(cache.get_or_set('key', nil, 1){ 'othervalue' }).to eq('value')
    sleep(2)
    expect(cache.get_or_set('key', nil, 1){ 'othervalue' }).to eq('othervalue')
  end

  it 'set & test value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    expect(cache.include?('key')).to be(true)
  end

  it 'get or set value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    expect(cache.get('key')).to eq('value')
    cache.get_or_set('key', 'value1')
    expect(cache.get('key')).to eq('value')
    cache.get_or_set('key1', 'value2')
    expect(cache.get('key1')).to eq('value2')
  end

  it 'set, delete & get value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    expect(cache.get('key')).to eq('value')
    cache.delete('key')
    expect(cache.get('key')).to be(nil)
  end

  it 'set, clear & get value' do
    cache = Prismic::LruCache.new
    cache.expired?('key')
    cache.set('key', 'value')
    cache.set('key1', 'value1')
    cache.set('key2', 'value2')
    expect(cache.get('key')).to eq('value')
    expect(cache.get('key1')).to eq('value1')
    expect(cache.get('key2')).to eq('value2')
    cache.clear!
    expect(cache.get('key')).to be(nil)
    expect(cache.get('key1')).to be(nil)
    expect(cache.get('key2')).to be(nil)
  end
end

describe 'BasicNullCache' do
  subject { Prismic::BasicNullCache.new }
  it 'always misses' do
    expect(subject.get('key')).to be(nil)
    expect(subject.set('key', 'value')).to eq('value')
    expect(subject.get('key')).to be(nil)
  end
  it 'set uses value if no block' do
    expect(subject.set('key', 'value')).to eq('value')
  end
  it 'set uses block if provided' do
    expect(subject.set('key', 'value'){'value2'}).to eq('value2')
  end
  it 'get_or_set uses value if no block' do
    expect(subject.get_or_set('key', 'value')).to eq('value')
  end
  it 'get_or_set uses block if provided' do
    expect(subject.get_or_set('key', 'value'){'value2'}).to eq('value2')
  end
end
