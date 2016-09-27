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
      @api.has_cache?.should == true
      @cache.is_a?(Prismic::LruCache).should == true
    end

    it "is properly off" do
      api = Prismic.api("https://micro.prismic.io/api", cache: nil)
      api.has_cache?.should == false
    end

    describe 'storage and retrieval' do
      it 'stores properly' do
        @cache.intern.size.should == 0
        @api.form('arguments').submit(@master_ref)
        @cache.intern.size.should == 1
      end

      it 'does not cache /api' do
        # do not call anything, so the only request made is the /api one
        @cache.intern.size.should == 0
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
        @cache.include?('fake_key1').should be_true
      end
      it 'contains all keys' do
        @cache.intern.size.should == 3
      end
      it 'can return all keys' do
        @cache.keys.should == %w(fake_key1 fake_key2 fake_key3)
      end
      it 'keeps readed keys alive' do
        @cache['fake_key1']
        @cache['fake_key4'] = 4
        @cache.include?('fake_key1').should be_true
        @cache.include?('fake_key2').should be_false
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
        @api.form('everything').submit(@master_ref).total_results_size.should == 18
        @api.form('everything').submit(@other_ref).total_results_size.should == 19
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
    cache.get('key').should == 'value'
  end

  it 'set with expiration value & get value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value', 1)
    sleep(2)
    cache.get('key').should == nil
  end

  it 'set with expiration and a block' do
    cache = Prismic::LruCache.new
    cache.get_or_set('key', nil, 1){ 'value' }
    cache.get_or_set('key', nil, 1){ 'othervalue' }.should == 'value'
    sleep(2)
    cache.get_or_set('key', nil, 1){ 'othervalue' }.should == 'othervalue'
  end

  it 'set & test value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    cache.include?('key').should == true
  end

  it 'get or set value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    cache.get('key').should == 'value'
    cache.get_or_set('key', 'value1')
    cache.get('key').should == 'value'
    cache.get_or_set('key1', 'value2')
    cache.get('key1').should == 'value2'
  end

  it 'set, delete & get value' do
    cache = Prismic::LruCache.new
    cache.set('key', 'value')
    cache.get('key').should == 'value'
    cache.delete('key')
    cache.get('key').should == nil
  end

  it 'set, clear & get value' do
    cache = Prismic::LruCache.new
    cache.expired?('key')
    cache.set('key', 'value')
    cache.set('key1', 'value1')
    cache.set('key2', 'value2')
    cache.get('key').should == 'value'
    cache.get('key1').should == 'value1'
    cache.get('key2').should == 'value2'
    cache.clear!
    cache.get('key').should == nil
    cache.get('key1').should == nil
    cache.get('key2').should == nil
  end
end

describe 'BasicNullCache' do
  subject { Prismic::BasicNullCache.new }
  it 'always misses' do
    subject.get('key').should == nil
    subject.set('key', 'value').should == 'value'
    subject.get('key').should == nil
  end
  it 'set uses value if no block' do
    subject.set('key', 'value').should == 'value'
  end
  it 'set uses block if provided' do
    subject.set('key', 'value'){'value2'}.should == 'value2'
  end
  it 'get_or_set uses value if no block' do
    subject.get_or_set('key', 'value').should == 'value'
  end
  it 'get_or_set uses block if provided' do
    subject.get_or_set('key', 'value'){'value2'}.should == 'value2'
  end
end
