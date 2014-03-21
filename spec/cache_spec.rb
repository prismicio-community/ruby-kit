# encoding: utf-8
require 'spec_helper'

describe "Cache's" do

	describe 'on/off switch' do
		before do
			@api = Prismic.api("https://lesbonneschoses.prismic.io/api", cache: Prismic::Cache.new(3))
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
			it 'deletes oldest key when updating max_size' do
				@cache.max_size = 1
				@cache.size.should == 1
				@cache.include?('fake_key1').should be_false
				@cache.include?('fake_key2').should be_false
				@cache.include?('fake_key3').should be_true
			end
			it 'deletes oldest key when adding new one (at max_size)' do
				@cache['fake_key4'] = 4
				@cache.max_size = 3
				@cache.size.should == 3
				@cache.include?('fake_key1').should be_false
			end
			it 'keeps readed keys alive' do
				@cache['fake_key1']
				@cache['fake_key4'] = 4
				@cache.include?('fake_key1').should be_true
				@cache.include?('fake_key2').should be_false
			end
		end
	end
end
