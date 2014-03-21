# encoding: utf-8
require 'spec_helper'

describe "Cache's" do

	describe 'on/off switch' do
		before do
			@api = Prismic.api("https://lesbonneschoses.prismic.io/api", cache: Prismic::Cache.new)
			@cache = @api.cache
			@master_ref = @api.master_ref
		end

		it "is properly on" do
			@api.has_cache?.should == true
			@cache.is_a?(Prismic::Cache).should == true
		end

		it "is properly off" do
			api = Prismic.api("https://lesbonneschoses.prismic.io/api", cache: false)
			api.has_cache?.should == false
		end

		describe 'storage and retrieval' do
			it 'stores properly' do
				@cache.intern.size.should == 0
				@api.form('products').submit(@master_ref)
				@cache.intern.size.should == 1
			end

			it 'does not cache /api' do
				# do not call anything, so the only request made is the /api one
				@cache.intern.size.should == 0
			end
		end

		describe 'cache invalidation' do
			before do
				@cache.add('fake_ref', 'fake_cache_key', Object.new, @api)
				@cache.add('fake_ref2', 'fake_cache_key', Object.new, @api)
				@cache.add('fake_ref2', 'fake_cache_key2', Object.new, @api)
			end
			it 'contains some keys' do
				@cache.include?('fake_ref', 'fake_cache_key').should be_true
			end
			it 'stores well, again' do
				@cache.intern.size.should == 2
				@cache.intern['fake_ref2'].keys.size.should == 2
				@cache.intern['fake_ref2'].has_key?('fake_cache_key2').should == true
			end
			it 'does all_keys well' do
				@cache.all_keys.should == {
					"fake_ref" => ["fake_cache_key"],
					"fake_ref2" => ["fake_cache_key", "fake_cache_key2"]
				}
			end
			it 'invalidates well partially' do
				@cache.invalidate_all_but!('fake_ref')
				@cache.intern.size.should == 1
				@cache.intern.keys[0].should == 'fake_ref'
			end
		end
	end
end
