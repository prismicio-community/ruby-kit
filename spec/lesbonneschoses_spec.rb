# encoding: utf-8
require 'spec_helper'

describe 'LesBonnesChoses' do
	before do
		@api = Prismic.api("https://lesbonneschoses.prismic.io/api", nil)
		@master_ref = @api.master_ref
	end

	describe '/api' do
		it "API works" do
			@api.should_not be_nil
		end
	end

	describe 'query' do
		it "queries everything and returns 20 documents" do
			@api.create_search_form("everything").submit(@master_ref).size.should == 20
		end

		it "queries macarons (using a predicate) and returns 7 documents" do
			@api.create_search_form("everything")
				.query(%([[:d = any(document.tags, ["Macaron"])]]))
				.submit(@master_ref).size.should == 7
		end

		it "queries macarons (using a form) and returns 7 documents" do
			@api.create_search_form("macarons").submit(@master_ref).size.should == 7
		end

		it "queries macarons or cupcakes (using a form + a predicate) and returns 11 documents" do
			@api.create_search_form("products")
				.query(%([[:d = any(document.tags, ["Cupcake", "Macaron"])]]))
				.submit(@master_ref).size.should == 11
		end		
	end

	describe 'API::Document' do
		before do
			@document = @api.create_search_form('everything').query(%([[:d = at(document.id, "UkL0gMuvzYUANCpf")]])).submit(@master_ref)[0]
		end

		it 'Operator [] works on document' do
			@document['job-offer.name'].as_html(nil).should == '<h1>Pastry Dresser</h1>'
		end

		it 'Operator [] returns nil if wrong type' do
			@document['product.name'].should == nil
		end

		it 'Operator [] raises error if field is nonsense' do
			expect {
				@document['blablabla']
			}.to raise_error(ArgumentError, "Argument should contain one dot. Example: product.price")
		end
	end

end
