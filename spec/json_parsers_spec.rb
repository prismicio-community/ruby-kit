describe 'document_link_parser' do
  before do
    raw_json = <<json
      {
        "document": {
          "id": "UdUjvt_mqVNObPeO",
          "type": "product",
          "tags": ["Macaron"],
          "slug": "dark-chocolate-macaron"
        },
        "isBroken": false
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
    document_link.is_broken.should == false
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
