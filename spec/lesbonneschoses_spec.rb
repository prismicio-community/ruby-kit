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
			@api.form("everything").submit(@master_ref).size.should == 20
		end

		it "queries macarons (using a predicate) and returns 7 documents" do
			@api.form("everything")
				.query(%([[:d = any(document.tags, ["Macaron"])]]))
				.submit(@master_ref).size.should == 7
		end

		it "queries macarons (using a form) and returns 7 documents" do
			@api.form("macarons").submit(@master_ref).size.should == 7
		end

		it "queries macarons or cupcakes (using a form + a predicate) and returns 11 documents" do
			@api.form("products")
				.query(%([[:d = any(document.tags, ["Cupcake", "Macaron"])]]))
				.submit(@master_ref).size.should == 11
		end		
	end

	describe 'API::Document' do
		before do
			@document = @api.form('everything').query(%([[:d = at(document.id, "UkL0gMuvzYUANCpf")]])).submit(@master_ref)[0]
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

	describe 'fragments' do
		it "returns a correct as_text on a StructuredText" do
			@api.form("everything")
				.query(%([[:d = at(document.id, "UkL0gMuvzYUANCps")]]))
				.submit(@master_ref)[0].fragments['body'].as_text.should == "The end of a chapter the beginning of a new one Jean-Michel Pastranova, the founder of Les Bonnes Choses, and creator of the whole concept of modern fine pastry, has decided to step down as the CEO and the Director of Workshops of Les Bonnes Choses, to focus on other projects, among which his now best-selling pastry cook books, but also to take on a primary role in a culinary television show to be announced later this year. \"I believe I've taken the Les Bonnes Choses concept as far as it can go. Les Bonnes Choses is already an entity that is driven by its people, thanks to a strong internal culture, so I don't feel like they need me as much as they used to. I'm sure they are greater ways to come, to innovate in pastry, and I'm sure Les Bonnes Choses's coming innovation will be even more mind-blowing than if I had stayed longer.\" He will remain as a senior advisor to the board, and to the workshop artists, as his daughter Selena, who has been working with him for several years, will fulfill the CEO role from now on. \"My father was able not only to create a revolutionary concept, but also a company culture that puts everyone in charge of driving the company's innovation and quality. That gives us years, maybe decades of revolutionary ideas to come, and there's still a long, wonderful path to walk in the fine pastry world.\""
		end

		it "returns a correct as_text on a StructuredText with a separator" do
			@api.form("everything")
				.query(%([[:d = at(document.id, "UkL0gMuvzYUANCps")]]))
				.submit(@master_ref)[0].fragments['body'].as_text(' #### ').should == "The end of a chapter the beginning of a new one #### Jean-Michel Pastranova, the founder of Les Bonnes Choses, and creator of the whole concept of modern fine pastry, has decided to step down as the CEO and the Director of Workshops of Les Bonnes Choses, to focus on other projects, among which his now best-selling pastry cook books, but also to take on a primary role in a culinary television show to be announced later this year. #### \"I believe I've taken the Les Bonnes Choses concept as far as it can go. Les Bonnes Choses is already an entity that is driven by its people, thanks to a strong internal culture, so I don't feel like they need me as much as they used to. I'm sure they are greater ways to come, to innovate in pastry, and I'm sure Les Bonnes Choses's coming innovation will be even more mind-blowing than if I had stayed longer.\" #### He will remain as a senior advisor to the board, and to the workshop artists, as his daughter Selena, who has been working with him for several years, will fulfill the CEO role from now on. #### \"My father was able not only to create a revolutionary concept, but also a company culture that puts everyone in charge of driving the company's innovation and quality. That gives us years, maybe decades of revolutionary ideas to come, and there's still a long, wonderful path to walk in the fine pastry world.\""
		end
	end
end
