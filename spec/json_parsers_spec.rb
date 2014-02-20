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
    @json = JSON.parse(raw_json)
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
    @json = JSON.parse(raw_json)
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

describe 'documents_parser' do

  it "accepts basic documents response" do
    @json = JSON.parse('{ "page": 1,
      "results_per_page": 20,
      "results_size": 20,
      "total_results_size": 40,
      "total_pages": 2,
      "next_page": "https://lesbonneschoses.prismic.io/api/documents/search?ref=UkL0hcuvzYUANCrm&page=2&pageSize=20",
      "prev_page": null,
      "results":[]}')
    @documents = Prismic::JsonParser.documents_parser(@json)
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
    @json = JSON.parse(raw_json)
  end

  it "correctly parses the Multiple object's elements" do
    multiple = Prismic::JsonParser.multiple_parser(@json)
    multiple.size.should == 2
    multiple[0].class.should == Prismic::Fragments::Text
    multiple[0].class.should == Prismic::Fragments::Text
  end
end

describe 'unknown_parser' do
  before do
    @raw_json = File.read("#{File.dirname(__FILE__)}/responses_mocks/document_with_unknown_fragment.json")
    @json = JSON.parse(@raw_json)
  end

  it "raises the proper error" do
    Prismic::JsonParser.should_receive(:warn).with("Type blabla is unknown, fragment was skipped; perhaps you should update your prismic.io gem?")
    Prismic::JsonParser.document_parser(@json).fragments.size.should == 2
  end
end