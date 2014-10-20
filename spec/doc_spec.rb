# encoding: utf-8
require 'spec_helper'

describe 'Documentation' do

  describe 'api' do

    it 'api.get' do
      # startgist:31cf4b514778d5d9d9cc:prismic-api.rb
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      # endgist
      api.should_not be_nil
    end

    it 'apiPrivate' do
      expect {
        # startgist:10822fc1befeeea1191a:prismic-apiPrivate.rb
        # This will fail because the token is invalid, but this is how to access a private API
        api = Prismic.api('https://lesbonneschoses.prismic.io/api', 'MC5-XXXXXXX-vRfvv70')
        # endgist
        # err.message, "Unexpected status code [401] on URL https://lesbonneschoses.prismic.io/api?access_token=MC5-XXXXXXX-vRfvv70"); // gisthide
      }.to raise_error(Prismic::API::PrismicWSAuthError, "Can't connect to Prismic's API: Invalid access token")
    end

    it 'references' do
      # startgist:431e191cabf5e160c701:prismic-references.rb
      preview_token = 'MC5VbDdXQmtuTTB6Z0hNWHF3.c--_vVbvv73vv73vv73vv71EA--_vS_vv73vv70T77-9Ke-_ve-_vWfvv70ebO-_ve-_ve-_vQN377-9ce-_vRfvv70';
      api = Prismic.api('https://lesbonneschoses.prismic.io/api', preview_token)
      st_patrick_ref = api.ref('St-Patrick specials')
      # Now we'll use this reference for all our calls
      response = api.form('everything')
      .ref(st_patrick_ref)
      .query(Prismic::Predicates::at('document.type', 'product'))
      .submit
      # The Response object contains all documents of type "product"
      # including the new "Saint-Patrick's Cupcake"
      # endgist
      response.results.length.should == 17
    end

  end

  describe 'queries' do

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

    it 'orderings' do
      # startgist:2866b2e2cae0221f2188:prismic-orderings.rb
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      response = api.form('everything')
        .ref(api.master_ref)
        .query(Prismic::Predicates::at('document.type', 'product'))
        .page_size(100)
        .orderings('[my.product.price desc]')
        .submit
      # The products are now ordered by price, highest first
      results = response.results
      # endgist
      response.results_per_page.should == 100
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

    it 'all predicates' do
      # startgist:e4875d732426a7b9fd09:prismic-allPredicates.rb
      # 'at' predicate: equality of a fragment to a value.
      at = Predicates::at('document.type', 'article')
      # 'any' predicate: equality of a fragment to a value.
      any = Predicates::any('document.type', ['article', 'blog-post'])

      # 'fulltext' predicate: fulltext search in a fragment.
      fulltext = Predicates::fulltext('my.article.body', 'sausage')

      # 'similar' predicate, with a document id as reference
      similar = Predicates::similar('UXasdFwe42D', 10)
      # endgist
      at.should == ['at', 'document.type', 'article']
      any.should == ['any', 'document.type', ['article', 'blog-post']]
    end

  end

  describe 'fragments' do

    it 'text' do
      api = Prismic::api('https://lesbonneschoses.prismic.io/api')
      response = api.form('everything')
        .query(Predicates::at('document.id', 'UlfoxUnM0wkXYXbl'))
        .ref(api.master_ref)
        .submit
      doc = response[0]
      # startgist:cd0d4559870f5f88b90f:prismic-getText.rb
      author = doc.get_text('blog-post.author')
      if author == nil
        name = 'Anonymous'
      else
        name = author.value
      end
      # endgist
      name.should == 'John M. Martelle, Fine Pastry Magazine'
    end

    it 'number' do
      api = Prismic::api('https://lesbonneschoses.prismic.io/api')
      response = api.form('everything')
        .query(Predicates::at('document.id', 'UlfoxUnM0wkXYXbO'))
        .ref(api.master_ref)
        .submit
      doc = response[0]
      # startgist:c6783e9789d3ff446876:prismic-getNumber.rb
      # Number predicates
      gt = Predicates::gt('my.product.price', 10)
      lt = Predicates::lt('my.product.price', 20)
      in_range = Predicates::in_range('my.product.price', 10, 20)

      # Accessing number fields
      price = doc.get_number('product.price').value
      # endgist
      price.should == 2.5
    end

    it 'date and timestamp' do
      api = Prismic::api('https://lesbonneschoses.prismic.io/api')
      response = api.form('everything')
        .query(Predicates::at('document.id', 'UlfoxUnM0wkXYXbl'))
        .ref(api.master_ref)
        .submit
      doc = response[0]
      # startgist:aa956ac3d7fb9c221011:prismic-dateTimestamp.rb
      # Date and Timestamp predicates
      dateBefore = Predicates::date_before('my.product.releaseDate', Time.new(2014, 6, 1))
      dateAfter = Predicates::date_after('my.product.releaseDate', Time.new(2014, 1, 1))
      dateBetween = Predicates::date_between('my.product.releaseDate', Time.new(2014, 1, 1), Time.new(2014, 6, 1))
      dayOfMonth = Predicates::day_of_month('my.product.releaseDate', 14)
      dayOfMonthAfter = Predicates::day_of_month_after('my.product.releaseDate', 14)
      dayOfMonthBefore = Predicates::day_of_month_before('my.product.releaseDate', 14)
      dayOfWeek = Predicates::day_of_week('my.product.releaseDate', 'Tuesday')
      dayOfWeekAfter = Predicates::day_of_week_after('my.product.releaseDate', 'Wednesday')
      dayOfWeekBefore = Predicates::day_of_week_before('my.product.releaseDate', 'Wednesday')
      month = Predicates::month('my.product.releaseDate', 'June')
      monthBefore = Predicates::month_before('my.product.releaseDate', 'June')
      monthAfter = Predicates::month_after('my.product.releaseDate', 'June')
      year = Predicates::year('my.product.releaseDate', 2014)
      hour = Predicates::hour('my.product.releaseDate', 12)
      hourBefore = Predicates::hour_before('my.product.releaseDate', 12)
      hourAfter = Predicates::hour_after('my.product.releaseDate', 12)

      # Accessing Date and Timestamp fields
      date = doc.get_date('blog-post.date').value
      date_year = date ? date.year : nil
      update_time = doc.get_timestamp('blog-post.update')
      update_hour = update_time ? update_time.value.hour : nil
      # endgist
      date_year.should == 2013
    end

    it 'group' do
      json = '{"id":"abcd","type":"article","href":"","slugs":[],"tags":[],"data":{"article":{"documents":{"type":"Group","value":[{"linktodoc":{"type":"Link.document","value":{"document":{"id":"UrDejAEAAFwMyrW9","type":"doc","tags":[],"slug":"installing-meta-micro"},"isBroken":false}},"desc":{"type":"StructuredText","value":[{"type":"paragraph","text":"A detailed step by step point of view on how installing happens.","spans":[]}]}},{"linktodoc":{"type":"Link.document","value":{"document":{"id":"UrDmKgEAALwMyrXA","type":"doc","tags":[],"slug":"using-meta-micro"},"isBroken":false}}}]}}}}'
      document = Prismic::JsonParser.document_parser(JSON.load(json))
      resolver = Prismic.link_resolver('master') { |doc_link| "http://localhost/#{doc_link.id}" }
      # startgist:825cff092f082058520d:prismic-group.rb
      group = document.get_group('article.documents')
      docs = group ? group : []
      docs.each do |doc|
        # Desc and Link are Fragments, their type depending on what's declared in the Document Mask
        desc = doc['desc']
        link = doc['linktodoc']
      end
      # endgist
      docs[0]['desc'].as_html(resolver).should == '<p>A detailed step by step point of view on how installing happens.</p>'
    end

    it 'link' do
      json = '{"id":"abcd","type":"article","href":"","slugs":[],"tags":[],"data":{"article":{"source":{"type":"Link.document","value":{"document":{"id":"UlfoxUnM0wkXYXbE","type":"product","tags":["Macaron"],"slug":"dark-chocolate-macaron"},"isBroken":false}}}}}'
      document = Prismic::JsonParser.document_parser(JSON.load(json))
      # startgist:6c7ae8d7ab6dc057a8b0:prismic-link.rb
      resolver = Prismic.link_resolver('master') { |doc_link| "http://localhost/#{doc_link.id}/#{doc_link.slug}" }
      source = document.get_link('article.source')
      url = source ? source.url(resolver) : nil
      # endgist
      url.should == 'http://localhost/UlfoxUnM0wkXYXbE/dark-chocolate-macaron'
    end

    it 'embed' do
      json = '{"id":"abcd","type":"article","href":"","slugs":[],"tags":[],"data":{"article":{"video":{"type":"Embed","value":{"oembed":{"provider_url":"http://www.youtube.com/","type":"video","thumbnail_height":360,"height":270,"thumbnail_url":"http://i1.ytimg.com/vi/baGfM6dBzs8/hqdefault.jpg","width":480,"provider_name":"YouTube","html":"<iframe width=\\"480\\" height=\\"270\\" src=\\"http://www.youtube.com/embed/baGfM6dBzs8?feature=oembed\\" frameborder=\\"0\\" allowfullscreen></iframe>","author_name":"Siobhan Wilson","version":"1.0","author_url":"http://www.youtube.com/user/siobhanwilsonsongs","thumbnail_width":480,"title":"Siobhan Wilson - All Dressed Up","embed_url":"https://www.youtube.com/watch?v=baGfM6dBzs8"}}}}}}'
      document = Prismic::JsonParser.document_parser(JSON.load(json))
      # startgist:d5a6c0715c9a8df984e4:prismic-embed.rb
      video = document.get_embed('article.video')
      # Html is the code to include to embed the object, and depends on the embedded service
      html = video ? video.as_html : ''
      # endgist
      html.should == '<div data-oembed="http://www.youtube.com/" data-oembed-type="video" data-oembed-provider="youtube"><iframe width="480" height="270" src="http://www.youtube.com/embed/baGfM6dBzs8?feature=oembed" frameborder="0" allowfullscreen></iframe></div>'
    end

    it 'color' do
      json = '{"id":"abcd","type":"article","href":"","slugs":[],"tags":[],"data":{"article":{"background":{"type":"Color","value":"#000000"}}}}'
      document = Prismic::JsonParser.document_parser(JSON.load(json))
      # startgist:ccafcdcbcd6ef6f2fce8:prismic-color.rb
      bgcolor = document.get_color('article.background')
      hex = '#' + (bgcolor ? bgcolor.value : 'FFFFFF')
      # endgist
      hex.should == '#000000'
    end

    it 'GeoPoint' do
      json = '{"id":"abcd","type":"article","href":"","slugs":[],"tags":[],"data":{"article":{"location":{"type":"GeoPoint","value":{"latitude":48.877108,"longitude":2.333879}}}}}'
      document = Prismic::JsonParser.document_parser(JSON.load(json))
      # startgist:c70626752d00669ee18f:prismic-geopoint.rb
      # "near" predicate for GeoPoint fragments
      near = Predicates::near('my.store.location', 48.8768767, 2.3338802, 10)

      # Accessing GeoPoint fragments
      place = document.get_geopoint('article.location')
      coordinates = place ? (place.latitude.to_s + ',' + place.longitude.to_s) : ''
      # endgist
      coordinates.should == '48.877108,2.333879'
    end

    it 'asHtml' do
      api = Prismic.api('https://lesbonneschoses.prismic.io/api')
      response = api
        .form('everything')
        .query(Prismic::Predicates::at('document.id', 'UlfoxUnM0wkXYXbX'))
        .submit(api.master_ref)
      # startgist:7bc04d4690b74e4d4a39:prismic-asHtml.rb
      resolver = Prismic.link_resolver('master'){ |doc_link| "http:#localhost/#{doc_link.id}" }
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
      resolver = Prismic.link_resolver('master'){ |doc_link| "http:#localhost/#{doc_link.id}" }
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

    it 'cache' do
      # startgist:a6b898cc3af15d7def0a:prismic-cache.rb
      # You can pass any object implementing the same methods as the BasicCache
      # https://github.com/prismicio/ruby-kit/blob/master/lib/prismic/cache/basic.rb
      cache = Prismic::BasicCache.new
      api = Prismic::api('https://lesbonneschoses.prismic.io/api', { :cache => cache })
      # The Api will use the custom cache object
      # endgist
      api.should_not be_nil
    end

  end

end
