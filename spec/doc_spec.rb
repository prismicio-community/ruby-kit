# encoding: utf-8
require 'spec_helper'

describe 'Documentation' do

  describe 'snippets' do

    it 'api' do
      # startgist:31cf4b514778d5d9d9cc:prismic-api.rb
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      puts api.refs
      # endgist
      api.should_not be_nil
    end

    it 'simple query' do
      # startgist:8943931ba0cf2bb2c873:prismic-simplequery.rb
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      response = api
        .form('everything')
        .query(Prismic::Predicates::at('document.type', 'product'))
        .submit(api.master_ref)
      # response contains all documents of type 'product', paginated
      # endgist
      response.results.size.should == 16
    end

    it 'predicates' do
      # startgist:e0501cce9a12fa4b83db:prismic-predicates.rb
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      response = api
        .form('everything')
        .query(
          Prismic::Predicates::at('document.type', 'product'),
          Prismic::Predicates::date_after('my.blog-post.date', 1401580800000))
        .submit(api.master_ref)
      # endgist
      response.results.size.should == 0
    end

    it 'asHtml' do
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      response = api
        .form('everything')
        .query(Prismic::Predicates::at('document.id', 'UlfoxUnM0wkXYXbX'))
        .submit(api.master_ref)
      # startgist:7bc04d4690b74e4d4a39:prismic-asHtml.rb
      resolver = Prismic.link_resolver('master'){ |doc_link| "http://localhost/#{doc_link.id}" }
      doc = response.results[0]
      html = doc['blog-post.body'].as_html(resolver)
      # endgist
      html.should_not be_nil
    end

    it 'HtmlSerializer' do
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      response = api
      .form('everything')
      .query(Prismic::Predicates::at('document.id', 'UlfoxUnM0wkXYXbX'))
      .submit(api.master_ref)
      # startgist:db34a3847be03315da55:prismic-htmlSerializer.rb
      resolver = Prismic.link_resolver('master'){ |doc_link| "http://localhost/#{doc_link.id}" }
      serializer = Prismic.html_serializer do |element, html|
        if element.is_a?(Prismic::Fragments::StructuredText::Block::Image)
          # Don't wrap images in a <p> tag
          %(<img src="#{element.url}" alt="#{element.alt}" width="#{element.width}" height="#{element.height}" />)
        else
          nil
        end
      end
      doc = response.results[0]
      html = doc['blog-post.body'].as_html(resolver, serializer)
      # endgist
      html.should_not be_nil
    end

  end

end
