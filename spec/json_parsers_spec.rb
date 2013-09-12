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
