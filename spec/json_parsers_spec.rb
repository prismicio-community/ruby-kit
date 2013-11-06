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
    @json = JSON.parse(raw_json)
  end

  it "correctly parses DocumentLinks" do
    document_link = Prismic::JsonParser.document_link_parser(@json)
    document_link.id.should == "UdUjvt_mqVNObPeO"
    document_link.link_type.should == "product"
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
    @json = JSON.parse(raw_json)
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
    @json = JSON.parse(raw_json)
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
    @json = JSON.parse(raw_json)
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
    @json = JSON.parse(raw_json)
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
    @json = JSON.parse(raw_json)
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
          "dimensions": {
            "width": 500,
            "height": 500
          }
        },
        "views": {
          "icon": {
            "url": "url2",
              "dimensions": {
                "width": 250,
                "height": 250
              }
          }
        }
      }
    }
json
    @json = JSON.parse(raw_json)
  end

  it "correctly parses Image objects" do
    image = Prismic::JsonParser.image_parser(@json)
    image.main.url.should == "url1"
    image.main.width.should == 500
    image.main.height.should == 500
    image.views[0].url.should == "url2"
    image.views[0].width.should == 250
    image.views[0].height.should == 250
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
    @json = JSON.parse(raw_json)
  end

  it "correctly parses Color objects" do
    color = Prismic::JsonParser.color_parser(@json)
    color.value.should == "ffeacd"
  end
end

describe 'structured_text_parser' do
  before do
    raw_json_paragraph = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_paragraph.json")
    json_paragraph = JSON.parse(raw_json_paragraph)
    @structured_text_paragraph = Prismic::JsonParser.structured_text_parser(json_paragraph)

    raw_json_heading = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_heading.json")
    json_heading = JSON.parse(raw_json_heading)
    @structured_text_heading = Prismic::JsonParser.structured_text_parser(json_heading)
  end

  describe 'headings parsing' do
    it "correctly parses headings" do
      @structured_text_heading.blocks[0].should be_a Prismic::Fragments::StructuredText::Block::Heading
      @structured_text_heading.blocks[0].text.should == "Salted Caramel Macaron"
      @structured_text_heading.blocks[0].level.should == 1
    end

    it "correctly parses >h9 heading" do
      json_heading = JSON.parse(<<-JSON)
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
    json = JSON.parse(raw_json)
    @document = Prismic::JsonParser.document_parser(json)
  end

  it "correctly parses Document objects" do
    @document.id.should == 'UdUkXt_mqZBObPeS'
    @document.type.should == 'product'
    @document.href.should == 'doc-url'
    @document.tags.should == ['Macaron']
    @document.slugs.should == ['vanilla-macaron']
  end

  it "correctly parses the document's fragments" do
    @document.fragments.size.should == 11
    @document.fragments['name'].should be_a Prismic::Fragments::StructuredText
  end
end

describe 'results_parser' do

  it "accepts results as an array" do
    @json = JSON.parse('[]')
    @results = Prismic::JsonParser.results_parser(@json)
    @results.should == []
  end

  it "accepts results as an object" do
    @json = JSON.parse('{"results":[]}')
    @results = Prismic::JsonParser.results_parser(@json)
    @results.should == []
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
    @json = JSON.parse(raw_json)
  end

  it "correctly parses the Multiple object's elements" do
    multiple = Prismic::JsonParser.multiple_parser(@json)
    multiple.size.should == 2
    multiple[0].class.should == Prismic::Fragments::Text
    multiple[0].class.should == Prismic::Fragments::Text
  end
end
