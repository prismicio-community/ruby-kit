# encoding: utf-8
require 'spec_helper'

describe 'Cache\'s' do
	describe 'on/off switch' do
		before do
			@api = Prismic.api("https://lesbonneschoses.prismic.io/api", {cache_class: Prismic::Cache})
			@master_ref = @api.master_ref
		end

		it "is properly on" do
			@api.cached?.should == true
			@api.cache.is_a?(Prismic::Cache).should == true
		end
		it "is properly off" do
			api = Prismic.api("https://lesbonneschoses.prismic.io/api")
			api.cached?.should == false
		end

		describe 'storage and retrieval' do
			it 'stores properly' do
				@api.cache.resultscache.size.should == 0
				@api.form('products').submit(@master_ref)
				@api.cache.resultscache.size.should == 1
			end

			it 'retrieves properly' do
				api = Prismic.api("https://lesbonneschoses.prismic.io/api", {cache_class: Prismic::Cache})
				api.cache.resultscache.size.should == 1
				api.cache.resultscache[api.master.ref].values[0].size.should == 16
			end
		end

		describe 'cache invalidation' do
			before do
				@api.cache.add('fake_ref', 'fake_cache_key', Object.new, @api)
				@api.cache.add('fake_ref2', 'fake_cache_key', Object.new, @api)
				@api.cache.add('fake_ref2', 'fake_cache_key2', Object.new, @api)
			end
			it 'stores well, again' do
				@api.cache.resultscache.size.should == 3
				@api.cache.resultscache['fake_ref2'].keys.size.should == 2
				@api.cache.resultscache['fake_ref2'].has_key?('fake_cache_key2').should == true
			end
			it 'does all_keys well' do
				@api.cache.all_keys.should == {"UkL0hcuvzYUANCrm"=>["GET::https://lesbonneschoses.prismic.io/api/documents/search?q=[\"[[:d = any(document.type, [\\\"product\\\"])]]\"]&page=1&pageSize=20"], "fake_ref"=>["fake_cache_key"], "fake_ref2"=>["fake_cache_key", "fake_cache_key2"]}
			end
			it 'invalidates well partially' do
				@api.cache.invalidate_all_but!('fake_ref')
				@api.cache.resultscache.size.should == 1
				@api.cache.resultscache.keys[0].should == 'fake_ref'
			end
		end
	end
end