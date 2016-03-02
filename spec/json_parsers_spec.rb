# encoding: utf-8
require 'spec_helper'

describe 'document_link_parser' do
  before do
    raw_json = <<json
      {
        "type": "Link.document",
        "value": {
          "document": {
            "id": "UdUjvt_mqVNObPeO",
            "type": "product",
            "tags": ["Macaron"],
            "slug": "dark-chocolate-macaron"
          },
          "isBroken": false
        }
      }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses DocumentLinks" do
    document_link = Prismic::JsonParser.document_link_parser(@json)
    document_link.id.should == "UdUjvt_mqVNObPeO"
    document_link.type.should == "product"
    document_link.tags.should == ['Macaron']
    document_link.slug.should == "dark-chocolate-macaron"
    document_link.broken?.should == false
  end
end

describe 'text_parser' do
  before do
    raw_json = <<json
    {
      "type": "Text",
      "value": "New York City, NY"
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses Text objects" do
    text = Prismic::JsonParser.text_parser(@json)
    text.value.should == "New York City, NY"
  end
end

describe 'web_link_parser' do
  before do
    raw_json = <<json
    {
      "type": "Link.web",
      "value": {
        "url": "http://prismic.io"
      }
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses WebLinks objects" do
    web_link = Prismic::JsonParser.web_link_parser(@json)
    web_link.url.should == "http://prismic.io"
  end
end

describe 'date_parser' do
  before do
    raw_json = <<json
    {
      "type": "date",
      "value": "2013-09-19"
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses Date objects" do
    date = Prismic::JsonParser.date_parser(@json)
    date.value.should == Time.new(2013, 9, 19)
  end
end

describe 'number_parser' do
  before do
    raw_json = <<json
    {
      "type": "Number",
      "value": 3.55
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses Number objects" do
    number = Prismic::JsonParser.number_parser(@json)
    number.value.should == 3.55
  end
end

describe 'embed_parser' do
  before do
    @embed_type = "rich"
    @provider = "GitHub"
    @url = "https://gist.github.com"
    @html = '<script src="https://gist.github.com/dohzya/6762845.js"></script>'
    raw_json = <<json
    {
      "type": "embed",
      "value": {
        "oembed": {
          "version": "1.0",
          "type": #{@embed_type.to_json},
          "provider_name": #{@provider.to_json},
          "provider_url": #{@url.to_json},
          "html": #{@html.to_json},
          "gist": "dohzya/6762845",
          "embed_url": "https://gist.github.com/dohzya/6762845",
          "title": "dohzya/gist:6762845"
        }
      }
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses Embed objects" do
    embed = Prismic::JsonParser.embed_parser(@json)
    embed.embed_type.should == @embed_type
    embed.provider.should == @provider
    embed.url.should == @url
    embed.html.should == @html
  end
end

describe 'image_parser' do
  before do
    raw_json = <<json
    {
      "type": "Image",
      "value": {
        "main": {
          "url": "url1",
          "alt" : "Alternative",
          "copyright" : "CC-BY",
          "dimensions": {
            "width": 500,
            "height": 500
          }
        },
        "views": {
          "icon": {
            "url": "url2",
            "alt" : "Alternative2",
            "copyright" : "CC-0",
              "dimensions": {
                "width": 250,
                "height": 250
              }
          }
        }
      }
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses Image objects" do
    image = Prismic::JsonParser.image_parser(@json)
    image.main.url.should == "url1"
    image.main.width.should == 500
    image.main.height.should == 500
    image.main.alt.should == "Alternative"
    image.main.copyright.should == "CC-BY"
    image.views['icon'].url.should == "url2"
    image.views['icon'].width.should == 250
    image.views['icon'].height.should == 250
    image.views['icon'].alt.should == "Alternative2"
    image.views['icon'].copyright.should == "CC-0"
  end
end

describe 'geo_point_parser' do
  before do
    raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/document.json")
    json = JSON.load(raw_json)
    @document = Prismic::JsonParser.document_parser(json)
  end

  it 'correctly parses GeoPoint objects' do
    @document['product.location'].latitude.should == 48.877108
    @document['product.location'].longitude.should == -2.333879
  end

  it 'correctly serializes GeoPoint objects into HTML' do
    @document['product.location'].as_html.should == "<div class=\"geopoint\"><span class=\"longitude\">-2.333879</span><span class=\"latitude\">48.877108</span></div>"
  end
end

describe 'image_parser in StructuredText' do
  before do
    raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/document.json")
    json = JSON.load(raw_json)
    @document = Prismic::JsonParser.document_parser(json)
    @image_st = @document['product.linked_images']
  end

  it 'parses properly with links' do
    @image_st.blocks[2].link_to.url.should == 'http://google.com/'
  end

  it 'parses properly without links' do
    @image_st.blocks[5].link_to.should be_nil
  end

  it 'serializes properly as HTML' do
    expected = <<expected
<p>Here is some introductory text.</p>

<p>The following image is linked.</p>

<p class="block-img"><a href="http://google.com/"><img src="http://fpoimg.com/129x260" alt="" width="260" height="129" /></a></p>

<p><strong>More important stuff</strong></p>

<p>One more image, this one is not linked:</p>

<p class="block-img"><img src="http://fpoimg.com/199x300" alt="" width="300" height="199" /></p>
expected
    expected.chomp!
    link_resolver = Prismic.link_resolver("master"){|doc_link| "http://localhost/#{doc_link.id}" }
    @image_st.as_html(link_resolver).should == expected
  end
end

describe 'color_parser' do
  before do
    raw_json = <<json
    {
      "type": "Color",
      "value": "#ffeacd"
    }
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses Color objects" do
    color = Prismic::JsonParser.color_parser(@json)
    color.value.should == "ffeacd"
  end
end

describe 'file_link_parser' do
  before do
    raw_json = <<json
    {
      "type": "Link.file",
      "value": {
        "file": {
          "name": "2012_annual.report.pdf",
          "kind": "document",
          "url": "https://prismic-io.s3.amazonaws.com/annual.report.pdf",
          "size": "1282484"
        }
      }
    }
json
    @json = JSON.load(raw_json)
    @link_file = Prismic::JsonParser.file_link_parser(@json)
  end

  it 'correctly parses file links' do
    @link_file.url.should == "https://prismic-io.s3.amazonaws.com/annual.report.pdf"
    @link_file.kind.should == "document"
    @link_file.name.should == "2012_annual.report.pdf"
    @link_file.size.should == "1282484"
    @link_file.as_html.should == "<a href=\"https://prismic-io.s3.amazonaws.com/annual.report.pdf\">2012_annual.report.pdf</a>"
  end
end

describe 'structured_text_parser' do
  before do
    raw_json_paragraph = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_paragraph.json")
    json_paragraph = JSON.load(raw_json_paragraph)
    @structured_text_paragraph = Prismic::JsonParser.structured_text_parser(json_paragraph)

    raw_json_heading = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_heading.json")
    json_heading = JSON.load(raw_json_heading)
    @structured_text_heading = Prismic::JsonParser.structured_text_parser(json_heading)
  end

  describe 'headings parsing' do
    it "correctly parses headings" do
      @structured_text_heading.blocks[0].should be_a Prismic::Fragments::StructuredText::Block::Heading
      @structured_text_heading.blocks[0].text.should == "Salted Caramel Macaron"
      @structured_text_heading.blocks[0].level.should == 1
    end

    it "correctly parses >h9 heading" do
      json_heading = JSON.load(<<-JSON)
        {
          "type": "StructuredText",
          "value": [{
            "type": "heading10",
            "text": "Salted Caramel Macaron",
            "spans": []
          }]
        }
      JSON
      @structured_text_heading = Prismic::JsonParser.structured_text_parser(json_heading)
      @structured_text_heading.blocks[0].should be_a Prismic::Fragments::StructuredText::Block::Heading
      @structured_text_heading.blocks[0].level.should == 10
    end

    it "parses all the spans" do
      @structured_text_heading.blocks[0].spans.size.should == 1
    end
  end

  describe 'paragraphs parsing' do
    it "correctly parses paragraphs" do
      @structured_text_paragraph.blocks[0].should be_a Prismic::Fragments::StructuredText::Block::Paragraph
      @structured_text_paragraph.blocks[0].text.size.should == 224
    end
  end

  describe 'spans parsing' do
    it "parses all the spans" do
      @structured_text_paragraph.blocks[0].spans.size.should == 3
    end

    it "correctly parses the em spans" do
      @structured_text_paragraph.blocks[0].spans[0].start.should == 103
      @structured_text_paragraph.blocks[0].spans[0].end.should == 137
      @structured_text_paragraph.blocks[0].spans[0].should be_a Prismic::Fragments::StructuredText::Span::Em
    end

    it "correctly parses the strong spans" do
      @structured_text_paragraph.blocks[0].spans[2].should be_a Prismic::Fragments::StructuredText::Span::Strong
    end

    it "correctly parses the hyperlink spans" do
      @structured_text_paragraph.blocks[0].spans[1].should be_a Prismic::Fragments::StructuredText::Span::Hyperlink
      @structured_text_paragraph.blocks[0].spans[1].link.should be_a Prismic::Fragments::WebLink
    end
  end
end

describe 'document_parser' do
  before do
    raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/document.json")
    json = JSON.load(raw_json)
    @document = Prismic::JsonParser.document_parser(json)
  end

  it "correctly parses Document objects" do
    @document.id.should == 'UdUkXt_mqZBObPeS'
    @document.type.should == 'product'
    @document.href.should == 'doc-url'
    @document.tags.should == ['Macaron']
    @document.slugs.should == ['vanilla-macaron', '南大沢']
  end

  it "correctly parses the document's fragments" do
    @document.fragments.size.should == 14
    @document.fragments['name'].should be_a Prismic::Fragments::StructuredText
  end
end

describe 'response_parser' do

  it "accepts basic documents response" do
    @json = JSON.load('{ "page": 1,
      "results_per_page": 20,
      "results_size": 20,
      "total_results_size": 40,
      "total_pages": 2,
      "next_page": "https://lesbonneschoses.prismic.io/api/documents/search?ref=UkL0hcuvzYUANCrm&page=2&pageSize=20",
      "prev_page": null,
      "results":[]}')
    @documents = Prismic::JsonParser.response_parser(@json)
    @documents.results.should == []
    @documents.page.should == 1
    @documents.results_per_page.should == 20
    @documents.results_size.should == 20
    @documents.total_results_size.should == 40
    @documents.total_pages.should == 2
    @documents.next_page.should == "https://lesbonneschoses.prismic.io/api/documents/search?ref=UkL0hcuvzYUANCrm&page=2&pageSize=20"
    @documents.prev_page.should == nil
  end

end

describe 'multiple_parser' do
  before do
    raw_json = <<json
      [
        {
          "type": "Text",
          "value": "foo"
        },
        {
          "type": "Text",
          "value": "bar"
        }
      ]
json
    @json = JSON.load(raw_json)
  end

  it "correctly parses the Multiple object's elements" do
    multiple = Prismic::JsonParser.multiple_parser(@json)
    multiple.size.should == 2
    multiple[0].class.should == Prismic::Fragments::Text
    multiple[0].class.should == Prismic::Fragments::Text
  end
end

describe 'timestamp_parser' do
  before do
    raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/document.json")
    json = JSON.load(raw_json)
    @document = Prismic::JsonParser.document_parser(json)
    @timestamp_fragment = @document['product.some_timestamp']
  end

  it 'correctly parses and stores a Time object' do
    @timestamp_fragment.value.utc.wednesday?.should == true
    @timestamp_fragment.value.min.should == 30
  end

  it 'outputs correctly as HTML' do
    @timestamp_fragment.as_html.should match /<time>2014-06-1\dT\d{2}:30:00\.000[-+]\d{2}:00<\/time>/
  end
end

describe 'unknown_parser' do
  before do
    @raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/document_with_unknown_fragment.json")
    @json = JSON.load(@raw_json)
  end

  it 'raises the proper error' do
    Prismic::JsonParser.should_receive(:warn).with("Type blabla is unknown, fragment was skipped; perhaps you should update your prismic.io gem?")
    Prismic::JsonParser.document_parser(@json).fragments.size.should == 2
  end
end

describe 'structured_text_label_parser' do
  before do
    raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_with_labels.json")
    json = JSON.load(raw_json)
    @structured_text = Prismic::JsonParser.structured_text_parser(json)
  end

  it 'outputs correctly as HTML' do
    link_resolver = Prismic.link_resolver("master"){|doc_link| "http://localhost/#{doc_link.id}" }
    @structured_text.as_html(link_resolver).should ==
        "<h1>Tips to dress a pastry</h1>\n\n" +
            "<p class=\"block-img\"><img src=\"https://prismic-io.s3.amazonaws.com/lesbonneschoses-vcerzcwaaohojzo/381f3a78dfe952b229fb49ceaa9926f7009ae20a.jpg\" alt=\"\" width=\"640\" height=\"666\" /></p>\n\n" +
            "<p>Our Pastry Dressers (yes, it is <a href=\"http://localhost/UlfoxUnM0wkXYXbh\">a full-time job</a> in <em>Les Bonnes Choses</em>!) have it somewhat different from our other pastry artists: while the others keep their main focus on the taste, smell, and potentially touch of your pastries, the Pastry Dressers are mainly focused on their looks.</p>\n\n" +
            "<p>It sometimes makes them feem like they&#39;re doing a job that is reasonably different from plain old pastry, and to make the most of your pastry dressings, perhaps so should you!</p>\n\n" +
            "<h2>Step by step</h2>\n\n" +
            "<p>From bottom to top, the steps towards a great dressing are pretty clear, and change rarely.</p>\n\n" +
            "<h3>Pastry Dresser, or speleologist?</h3>\n\n" +
            "<p>One of the first handy phases of dressing your pastry will be about carving to get to a desired shape and size to build upon. This is very precise work, as you will need to <span class=\"author\">clean</span> the object without breaking it, to remove pieces of it while keeping intact the meaningful bits. Now you&#39;re ready to iterate upon it!</p>\n\n" +
            "<h3>Pastry Dresser, or clay sculptor?</h3>\n\n<p>" +
            "Then, you will need to shape your piece of art <span class=\"author\"><strong>into</strong></span> the design you have in mind, by adding the right materials to just the right places. Ganache is your friend in such moments, such as any shape-free material. You&#39;ll have to master them, so they obey to the shapes you have in mind.</p>\n\n" +
            "<h3>Pastry Dresser, or hairdresser?</h3>\n\n" +
            "<p>The top of the pastry is a priority zone for finalization. This is where your &quot;last touch&quot; goes, and it&#39;s tremendously important, as it gives the pastry most of its character. You will have to play with the details, to keep the top of your piece on the... top of your priorities!</p>\n\n<h2>Before starting</h2>\n\n<p>" +
            "Finishing by the beginning: what did we have to consider, before running towards the aforementioned steps?</p>\n\n" +
            "<p class=\"block-img\"><img src=\"https://prismic-io.s3.amazonaws.com/lesbonneschoses-vcerzcwaaohojzo/502ebb427b5eb45693800816fc778316c04935f5.jpg\" alt=\"\" width=\"640\" height=\"427\" /></p>\n\n" +
            "<h3>Pastry Dresser, or illustrator?</h3>\n\n" +
            "<p>We didn&#39;t mention color, but it&#39;s a very important component of the piece. Just like an illustrator will pick colors that add to the shape in a matching way to keep a perfect meaning, the colors must be perfect to be consistent with the taste of the piece (do not use green-colored sugar for a strawberry-flavored pastry, if you don&#39;t want to gross people out!)</p>\n\n" +
            "<h3>Pastry Dresser, or designer?</h3>\n\n<p>And even before the illustration and colors, you really need to take the time to think about your destination, to make sure it&#39;s nothing short of perfect. This may imply taking the time to sit down for a few minutes with a paper and a pen. The first skill of an imaginative Pastry Dresser is a drawing skill, just like a fashion stylist.</p>"
  end

end
