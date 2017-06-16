# encoding: utf-8
require 'spec_helper'

describe 'micro' do
  before do
    @api = Prismic.api('https://micro.prismic.io/api', nil)
    @master_ref = @api.master_ref
    @link_resolver = Prismic.link_resolver('master'){|doc_link| "http://localhost/#{doc_link.id}" }
  end

  describe 'embed block in structured text fragments' do
    it 'is of the right Embed object, and serializes well' do
      fragment = @api.form('everything').query(%w(at document.id UrjI1gEAALOCeO5i)).submit(@master_ref)[0]['article.body']
      expect(fragment.blocks[4].is_a?(Prismic::Fragments::Embed)).to be(true)

      block = %(<h2>The meta-micro mailing-list</h2><p>This is where you go to give feedback, and discuss the future of micro. <a href="https://groups.google.com/forum/?hl=en#!forum/micro-meta-framework">Subscribe to the list now</a>!</p><h2>The micro GitHub repository</h2><p>This is where you get truly active, by forking the project's source code, and making it better. Please always feel free to send us pull requests.</p><div data-oembed="" data-oembed-type="link" data-oembed-provider="object"><div data-type="object"><a href="https://github.com/rudyrigot/meta-micro"><h1>rudyrigot/meta-micro</h1><img src="https://avatars2.githubusercontent.com/u/552279?s=400"><p>The meta-micro-framework you simply need</p></a></div></div><h2>Report bugs on micro</h2><p>If you think micro isn't working properly in one of its features, <a href="https://github.com/rudyrigot/meta-micro/issues">open a new issue in the micro GitHub repository</a>.</p><h2>Ask for help</h2><p>Feel free to ask a new question <a href="http://stackoverflow.com/questions/tagged/meta-micro">on StackOverflow</a>.</p>)

      expect(fragment.as_html(@link_resolver).gsub(/[\n\r]+/, '').gsub(/ +/, ' ').gsub(/&#39;/, "'")).to eq(block)
    end
  end

  describe 'linked documents' do
    it 'should have linked documents' do
      response = @api.form('everything').query('[[:d = any(document.type, ["doc","docchapter"])]]').submit(@master_ref)
      linked_documents = response.results[0].linked_documents
      expect(linked_documents.count).to eq(1)
      expect(linked_documents[0].id).to eq('U0w8OwEAACoAQEvB')
    end
  end
end
