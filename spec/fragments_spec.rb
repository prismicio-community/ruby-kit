# encoding: utf-8
require 'spec_helper'

def em(start, stop)
  Prismic::Fragments::StructuredText::Span::Em.new(start, stop)
end
def strong(start, stop)
  Prismic::Fragments::StructuredText::Span::Strong.new(start, stop)
end

describe 'WebLink' do
  before do
      @web_link = Prismic::Fragments::WebLink.new('my_url')
  end
  describe 'as_html' do
    it "returns an <a> HTML element" do
      expect(Nokogiri::XML(@web_link.as_html).child.name).to eq('a')
    end

    it "returns a HTML element with an href attribute" do
      expect(Nokogiri::XML(@web_link.as_html).child.has_attribute?('href')).to be(true)
    end

    it "returns a HTML element with an href attribute pointing to the url" do
      expect(Nokogiri::XML(@web_link.as_html).child.attribute('href').value).to eq('my_url')
    end

    it "returns a HTML element whose content is the link" do
      expect(Nokogiri::XML(@web_link.as_html).child.content).to eq('my_url')
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @web_link.as_text }.to raise_error NotImplementedError
    end
  end

  describe 'url' do
    before do
      @link_resolver = Prismic.link_resolver("master"){|doc_link| "http://localhost/#{doc_link.id}" }
    end
    it 'works in a unified way' do
      expect(@web_link.url(@link_resolver)).to eq('my_url')
    end
  end
end

describe 'DocumentLink' do
  before do
    @document_link = Prismic::Fragments::DocumentLink.new("UdUjvt_mqVNObPeO", nil, "product", ["Macaron"], "dark-chocolate-macaron", "en-us", {}, false)
  end

  describe 'url' do
    before do
      @link_resolver = Prismic.link_resolver("master"){|doc_link| "http://localhost/#{doc_link.id}" }
    end
    it 'works in a unified way' do
      expect(@document_link.url(@link_resolver)).to eq('http://localhost/UdUjvt_mqVNObPeO')
    end
  end

  describe 'lang' do
    it 'is available' do
      expect(@document_link.lang).to eq('en-us')
    end
  end
end

describe 'ImageLink' do
  before do
    @image_link = Prismic::Fragments::ImageLink.new('my_url')
  end

  describe 'as_html' do

    it "returns an <a> HTML element" do
      expect(Nokogiri::XML(@image_link.as_html).child.name).to eq('a')
    end

    it "returns a HTML element with an href attribute" do
      expect(Nokogiri::XML(@image_link.as_html).child.has_attribute?('href')).to be(true)
    end

    it "returns a HTML element with an href attribute pointing to the url" do
      expect(Nokogiri::XML(@image_link.as_html).child.attribute('href').value).to eq('my_url')
    end

    it "returns a HTML element whose content is the link" do
      expect(Nokogiri::XML(@image_link.as_html).child.content).to eq('my_url')
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @image_link.as_text }.to raise_error NotImplementedError
    end
  end

  describe 'url' do
    before do
      @link_resolver = Prismic.link_resolver('master'){|doc_link| "http://localhost/#{doc_link.id}" }
    end
    it 'works in a unified way' do
      expect(@image_link.url(@link_resolver)).to eq('my_url')
    end
  end
end

describe 'FileLink' do
  describe 'in structured texts' do
    before do
      @raw_json_structured_text = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_linkfile.json")
      @json_structured_text = JSON.load(@raw_json_structured_text)
      @structured_text = Prismic::JsonParser.structured_text_parser(@json_structured_text)
    end
    it 'serializes well into HTML' do
      block = "<p><a href=\"https://prismic-io.s3.amazonaws.com/annual.report.pdf\">2012 Annual Report</a></p>\n\n"\
              "<p><a href=\"https://prismic-io.s3.amazonaws.com/annual.budget.pdf\">2012 Annual Budget</a></p>\n\n"\
              "<p><a href=\"https://prismic-io.s3.amazonaws.com/vision.strategic.plan_.sm_.pdf\">2015 Vision &amp; Strategic Plan</a></p>"
      expect(@structured_text.as_html(nil)).to eq(block)
    end
  end
end

describe 'Span' do
  describe 'in structured texts when end is at the end of line' do
    before do
      @raw_json_structured_text = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_with_tricky_spans.json")
      @json_structured_text = JSON.load(@raw_json_structured_text)
      @structured_text = Prismic::JsonParser.structured_text_parser(@json_structured_text)
    end
    it 'serializes well into HTML' do
      block = "<h3><strong>Powering Through 2013 </strong></h3>\n\n"\
              "<h3><strong>Online Resources:</strong></h3>\n\n"\
              "<ul><li>Hear more from our executive team as they reflect on 2013 and share their vision for 2014 on our blog <a href=\"http://prismic.io\">here</a></li></ul>"
      expect(@structured_text.as_html(nil)).to eq(block)
    end
  end
  describe 'in structured texts when multiple spans' do
    before do
      @raw_json_structured_text = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_paragraph.json")
      @json_structured_text = JSON.load(@raw_json_structured_text)
      @structured_text = Prismic::JsonParser.structured_text_parser(@json_structured_text)
    end
    it 'serializes well into HTML' do
      block = '<p class="vanilla">Experience <a href="http://prismic.io">the</a> ultimate vanilla experience.<br>'\
              'Our vanilla Macarons are made with our very own (in-house) <em>pure extract of Madagascar vanilla</em>, and subtly dusted with <strong>our own vanilla sugar</strong> (which we make from real vanilla beans).</p>'
      expect(@structured_text.as_html(nil)).to eq(block)
    end
  end
  describe 'in structured texts when image with link' do
    before do
      @raw_json_structured_text = File.read("#{File.dirname(__FILE__)}/responses_mocks/structured_text_image_with_link.json")
      @json_structured_text = JSON.load(@raw_json_structured_text)
      @structured_text = Prismic::JsonParser.structured_text_parser(@json_structured_text)
    end
    it 'serializes well into HTML' do
      block = '<p class="block-img"><a href="http://prismic.io"><img src="https://wroomdev.s3.amazonaws.com/tutoblanktemplate%2F97109f41-140e-4dc9-a2c8-96fb10f14051_star.gif" alt="" width="960" height="800" /></a></p>'
      expect(@structured_text.as_html(nil)).to eq(block)
    end
  end
end

describe 'Text' do
  before do
    @text = Prismic::Fragments::Text.new('my_value')
  end

  describe 'as_html' do

    it "returns a <span> HTML element" do
      expect(Nokogiri::XML(@text.as_html).child.name).to eq('span')
    end

    it "returns a HTML element with the 'text' class" do
      expect(Nokogiri::XML(@text.as_html).child.attribute('class').value.split).to include('text')
    end

    it "returns a HTML element whose content is the value" do
      expect(Nokogiri::XML(@text.as_html).child.content).to eq('my_value')
    end

    it "espaces HTML content" do
      @text = Prismic::Fragments::Text.new('&my <value> #abcde')
      expect(@text.as_html).to match(/^<[^>]+>&amp;my &lt;value&gt; #abcde<[^>]+>$/)
    end
  end

  describe 'as_text' do
    it 'return the value' do
      expect(@text.as_text).to eq('my_value')
    end
  end
end

describe 'Select' do
  before do
    @select = Prismic::Fragments::Select.new('my_value')
  end

  describe 'as_html' do

    it "returns a <span> HTML element" do
      expect(Nokogiri::XML(@select.as_html).child.name).to eq('span')
    end

    it "returns a HTML element with the 'text' class" do
      expect(Nokogiri::XML(@select.as_html).child.attribute('class').value.split).to include('text')
    end

    it "returns a HTML element whose content is the value" do
      expect(Nokogiri::XML(@select.as_html).child.content).to eq('my_value')
    end

    it "escapes HTML" do
      @select = Prismic::Fragments::Select.new('&my <value> #abcde')
      expect(@select.as_html(nil)).to match(%r{^<[^>]+>&amp;my &lt;value&gt; #abcde<[^>]+>$})
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @select.as_text }.to raise_error NotImplementedError
    end
  end
end

describe 'Date' do
  before do
    @date = Prismic::Fragments::Date.new(Time.new(2013, 8, 7, 11, 13, 7, '+02:00'))
  end

  describe 'as_html' do
    it "returns a <time> HTML element" do
      expect(Nokogiri::XML(@date.as_html).child.name).to eq('time')
    end

    it "returns a HTML element whose content is the date in the ISO8601 format" do
      expect(Nokogiri::XML(@date.as_html).child.content).to eq('2013-08-07T11:13:07.000+02:00')
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @date.as_text }.to raise_error NotImplementedError
    end
  end
end

describe 'Number' do
  before do
    @number = Prismic::Fragments::Number.new(10.2)
  end

  describe 'as_int' do
    it "returns an Integer" do
      expect(@number.as_int).to be_a_kind_of(Integer)
    end

    it "returns the integer representation of the number" do
      expect(@number.as_int).to eq(10)
    end
  end

  describe 'as_html' do
    it "returns a <span> HTML element" do
      expect(Nokogiri::XML(@number.as_html).child.name).to eq('span')
    end

    it "returns a HTML element with the class 'number'" do
      expect(Nokogiri::XML(@number.as_html).child.attribute('class').value.split).to include('number')
    end

    it "returns a HTML element whose content is the value" do
      expect(Nokogiri::XML(@number.as_html).child.content).to eq(10.2.to_s)
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @number.as_text }.to raise_error NotImplementedError
    end
  end
end

describe 'Color' do
  before do
    @hex_value = '00FF99'
    @color = Prismic::Fragments::Color.new(@hex_value)
  end

  describe 'asRGB' do
    it "returns a hash" do
      expect(@color.asRGB).to be_a_kind_of(Hash)
    end

    it "returns a hash of 3 elements" do
      expect(@color.asRGB.size).to eq(3)
    end

    it "returns the correct red value" do
      expect(@color.asRGB['red']).to eq(0)
    end

    it "returns the correct green value" do
      expect(@color.asRGB['green']).to eq(255)
    end

    it "returns the correct blue value" do
      expect(@color.asRGB['blue']).to eq(153)
    end
  end

  describe 'self.asRGB' do
    before do
      @color = Prismic::Fragments::Color
    end

    it "returns a hash" do
      expect(@color.asRGB(@hex_value)).to be_a_kind_of(Hash)
    end

    it "returns a hash of 3 elements" do
      expect(@color.asRGB(@hex_value).size).to eq(3)
    end

    it "returns the correct red value" do
      expect(@color.asRGB(@hex_value)['red']).to eq(0)
    end

    it "returns the correct green value" do
      expect(@color.asRGB(@hex_value)['green']).to eq(255)
    end

    it "returns the correct blue value" do
      expect(@color.asRGB(@hex_value)['blue']).to eq(153)
    end
  end

  describe 'as_html' do
    it "returns a <span> HTML element" do
      expect(Nokogiri::XML(@color.as_html).child.name).to eq('span')
    end

    it "returns a HTML element with the class 'color'" do
      expect(Nokogiri::XML(@color.as_html).child.attribute('class').value.split).to include('color')
    end

    it "returns a HTML element whose content is the value" do
      expect(Nokogiri::XML(@color.as_html).child.content).to eq("##@hex_value")
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @color.as_text }.to raise_error NotImplementedError
    end
  end

  describe 'self.valid?' do
    it "returns true if the color is valid" do
      expect(Prismic::Fragments::Color.valid?(@hex_value)).to be(true)
    end

    it "returns false if the color is not valid" do
      expect(Prismic::Fragments::Color.valid?("I'm a murloc")).to be(false)
    end
  end
end

describe 'Embed' do
  before do
    @embed = Prismic::Fragments::Embed.new(
      'MY_TYPE',
      'MY_PROVIDER',
      'my_url',
      'my_html',
      'my_oembed_json'
    )
  end

  describe 'as_html' do
    it "returns a div element" do
      expect(Nokogiri::XML(@embed.as_html).child.name).to eq('div')
    end

    it "returns an element with a data-oembed attribute" do
      expect(Nokogiri::XML(@embed.as_html).child.has_attribute?('data-oembed')).to be(true)
    end

    it "returns an element with a data-oembed attribute containing the url" do
      expect(Nokogiri::XML(@embed.as_html).child.attribute('data-oembed').value).to eq('my_url')
    end

    it "returns an element with a data-oembed-type attribute" do
      expect(Nokogiri::XML(@embed.as_html).child.has_attribute?('data-oembed-type')).to be(true)
    end

    it "returns an element with a data-oembed-type attribute containing the type in lowercase" do
      expect(Nokogiri::XML(@embed.as_html).child.attribute('data-oembed-type').value).to eq('my_type')
    end

    it "returns an element with a data-oembed-provider attribute" do
      expect(Nokogiri::XML(@embed.as_html).child.has_attribute?('data-oembed-provider')).to be(true)
    end

    it "returns an element with a data-oembed-provider attribute containing the provider in lowercase" do
      expect(Nokogiri::XML(@embed.as_html).child.attribute('data-oembed-provider').value).to eq('my_provider')
    end

    it "returns an element wrapping the `html` value" do
      expect(Nokogiri::XML(@embed.as_html).child.content).to eq('my_html')
    end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @embed.as_text }.to raise_error NotImplementedError
    end
  end
end

describe 'Image::View' do
  before do
    @url = 'my_url'
    @width = 10
    @height = 2
    @view = Prismic::Fragments::Image::View.new(@url, @width, @height, "", "", nil)
  end

  describe 'ratio' do
    it "returns the width/height ratio of the image" do
      expect(@view.ratio).to eq(@width / @height)
    end
  end

  describe 'as_html' do
    it "return an <img> HTML element" do
      expect(Nokogiri::XML(@view.as_html).child.name).to eq('img')
    end

    it "returns an element whose `src` attribute equals the url" do
      expect(Nokogiri::XML(@view.as_html).child.attribute('src').value).to eq(@url)
    end

    it "returns an element whose `width` attribute equals the width" do
      expect(Nokogiri::XML(@view.as_html).child.attribute('width').value).to eq(@width.to_s)
    end

    it "returns an element whose `height` attribute equals the height" do
      expect(Nokogiri::XML(@view.as_html).child.attribute('height').value).to eq(@height.to_s)
    end

    it "if set, returns an element whose `alt` attribute equals the alt" do
      @alt = "Alternative text"
      @view.alt = @alt
      expect(Nokogiri::XML(@view.as_html).child.attribute('alt').value).to eq(@alt)
    end

    # it "if not set, alt attribute is absent" do
    #   Nokogiri::XML(@view.as_html).child.attribute('alt')).to eq(nil)
    # end
  end

  describe 'as_text' do
    it 'raises an NotImplementedError' do
      expect { @view.as_text }.to raise_error NotImplementedError
    end
  end
end

describe 'Image' do
  before do
    @main_view = Prismic::Fragments::Image::View.new('my_url', 10, 10, "Alternative", "CC-BY", nil)
    @another_view = Prismic::Fragments::Image::View.new('my_url2', 20, 20, "", "", nil)
    @image = Prismic::Fragments::Image.new(@main_view, { 'another_view' => @another_view })
  end

  describe 'get_view' do
    it "returns `main`'s value is asked for`" do
      expect(@image.get_view('main')).to eq(@main_view)
    end

    it "returns the value of the specified key" do
      expect(@image.get_view('another_view')).to eq(@another_view)
    end

    it "raises an error if the key does not exist" do
      expect { @image.get_view('foo') }.to raise_error Prismic::Fragments::Image::ViewDoesNotExistException
    end
  end

  describe 'as_html' do
    it "returns the HTML representation of the main view" do
      expect(Nokogiri::XML(@image.as_html).child.name).to eq(Nokogiri::XML(@main_view.as_html).child.name)
      expect(Nokogiri::XML(@image.as_html).child.attribute('src').value).to eq(Nokogiri::XML(@main_view.as_html).child.attribute('src').value)
      expect(Nokogiri::XML(@image.as_html).child.attribute('width').value).to eq(Nokogiri::XML(@main_view.as_html).child.attribute('width').value)
      expect(Nokogiri::XML(@image.as_html).child.attribute('height').value).to eq(Nokogiri::XML(@main_view.as_html).child.attribute('height').value)
      expect(Nokogiri::XML(@image.as_html).child.attribute('alt').value).to eq(Nokogiri::XML(@main_view.as_html).child.attribute('alt').value)
    end
  end

  describe 'as_text' do
    it 'is empty' do
      expect(@image.as_text).to eq("")
    end
  end
end

describe 'StructuredText' do
  before do
    @structuredtext = Prismic::Fragments::StructuredText.new([
      Prismic::Fragments::StructuredText::Block::Text.new("This is not a title", []),
      Prismic::Fragments::StructuredText::Block::Heading.new("This is a title, but not the highest", [], 3),
      Prismic::Fragments::StructuredText::Block::Heading.new("Document's title", [], 1),
      Prismic::Fragments::StructuredText::Block::Text.new("This is not a title", [])
    ])
  end
  it 'finds the text of the first block' do
    expect(@structuredtext.blocks[0].text).to eq("This is not a title")
  end
  it 'finds the right title if exists' do
    expect(@structuredtext.first_title).to eq("Document's title")
  end
  it 'returns false if no title' do
    @structuredtext.blocks[1] = Prismic::Fragments::StructuredText::Block::Text.new("This is not a title either", [])
    @structuredtext.blocks[2] = Prismic::Fragments::StructuredText::Block::Text.new("And this is not a title either", [])
    expect(@structuredtext.first_title).to eq(false)
  end
end

describe 'StructuredText::Heading' do
  before do
    @text = 'This is a simple test.'
    @spans = [em(5, 7), strong(8, 9)]
  end
  let :block do Prismic::Fragments::StructuredText::Block::Heading.new(@text, @spans, @heading) end
  it 'generates valid h1 html' do
    @heading = 1
    expect(block.as_html(nil)).to eq('<h1>This <em>is</em> <strong>a</strong> simple test.</h1>')
  end
  it 'generates valid h2 html' do
    @heading = 2
    expect(block.as_html(nil)).to eq('<h2>This <em>is</em> <strong>a</strong> simple test.</h2>')
  end
end

describe 'StructuredText::Paragraph' do
  let :block do Prismic::Fragments::StructuredText::Block::Paragraph.new(@text, @spans) end
  it 'generates valid html' do
    @text  = "This is a simple test."
    @spans = [em(5, 7), strong(8, 9)]
    expect(block.as_html(nil)).to eq("<p>This <em>is</em> <strong>a</strong> simple test.</p>")
  end
  it "espaces HTML content" do
    @text  = '&my <value> #abcde'
    @spans = [em(4, 11), strong(0, 1)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+><strong>&amp;</strong>my <em>&lt;value&gt;</em> #abcde<[^>]+>$})
  end
  it "espaces HTML content (many spans)" do
    @text  = 'abcdefghijklmnopqrstuvwxyz'
    @spans = [em(1, 3), strong(5, 7), em(9, 11), strong(13, 15)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+>a<em>bc</em>de<strong>fg</strong>hi<em>jk</em>lm<strong>no</strong>pqrstuvwxyz<[^>]+>$})
  end
  it "espaces HTML content (empty spans)" do
    @text  = 'abcdefghijklmnopqrstuvwxyz'
    @spans = [em(2, 2)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+>abcdefghijklmnopqrstuvwxyz<[^>]+>$})
  end
  it "espaces HTML content (2 spans on the same text)" do
    @text  = 'abcdefghijklmnopqrstuvwxyz'
    @spans = [em(2, 4), strong(2, 4)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+>ab<em><strong>cd</strong></em>efghijklmnopqrstuvwxyz<[^>]+>$})
  end
  it "espaces HTML content (2 spans on the same text - one bigger 1)" do
    @text  = 'abcdefghijklmnopqrstuvwxyz'
    @spans = [em(2, 6), strong(2, 4)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+>ab<em><strong>cd</strong>ef</em>ghijklmnopqrstuvwxyz<[^>]+>$})
  end
  it "espaces HTML content (2 spans on the same text - one bigger 2)" do
    @text  = 'abcdefghijklmnopqrstuvwxyz'
    @spans = [em(2, 4), strong(2, 6)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+>ab<strong><em>cd</em>ef</strong>ghijklmnopqrstuvwxyz<[^>]+>$})
  end
  it "espaces HTML content (span next to span)" do
    @text  = 'abcdefghijklmnopqrstuvwxyz'
    @spans = [em(2, 4), strong(4, 6)]
    expect(block.as_html(nil)).to match(%r{^<[^>]+>ab<em>cd</em><strong>ef</strong>ghijklmnopqrstuvwxyz<[^>]+>$})
  end
end

describe 'StructuredText::Preformatted' do
  let :block do Prismic::Fragments::StructuredText::Block::Preformatted.new(@text, @spans) end
  it 'generates valid html' do
    @text  = "This is a simple test."
    @spans = [em(5, 7), strong(8, 9)]
    expect(block.as_html(nil)).to eq("<pre>This <em>is</em> <strong>a</strong> simple test.</pre>")
  end
end

describe 'StructuredText::Image' do
  before do
    @view = Prismic::Fragments::Image::View.new('my_url', 10, 10, "Aternative", "CC-BY", nil)
    @image = Prismic::Fragments::StructuredText::Block::Image.new(@view)
  end

  describe 'url' do
    it "returns the view's url" do
      expect(@image.url).to eq(@view.url)
    end
  end

  describe 'width' do
    it "returns the view's width" do
      expect(@image.width).to eq(@view.width)
    end
  end

  describe 'height' do
    it "returns the view's height" do
      expect(@image.height).to eq(@view.height)
    end
  end

  describe 'alt' do
    it "returns the view's alt" do
      expect(@image.alt).to eq(@view.alt)
    end
  end

  describe 'copyright' do
    it "returns the view's copyright" do
      expect(@image.copyright).to eq(@view.copyright)
    end
  end
end

describe 'StructuredText::Hyperlink' do
  before do
    @link = Prismic::Fragments::DocumentLink.new(
      "UdUjvt_mqVNObPeO",
      nil,
      "product",
      ["Macaron"],
      "dark-chocolate-macaron",
      "fr-fr",
      {},
      false  # not broken
    )
    @hyperlink = Prismic::Fragments::StructuredText::Span::Hyperlink.new(0, 0, @link)
    @link_resolver = Prismic.link_resolver("master"){|doc_link| "http://localhost/#{doc_link.id}" }
  end

  describe 'as_html' do
    it "can generate valid link" do
      expect(@hyperlink.serialize('', @link_resolver)).to eq('<a href="http://localhost/UdUjvt_mqVNObPeO"></a>')
    end
    it "raises an error when no link_resolver provided" do
      expect { @hyperlink.serialize('', nil) }.to raise_error(RuntimeError)
    end
    it "can generate valid html for broken link" do
      @link.broken = true
      expect(@hyperlink.serialize('', @link_resolver)).to eq('<span></span>')
    end
  end
end

describe 'Multiple' do
  before do
    @multiple = Prismic::Fragments::Multiple.new
  end

  describe 'push' do
    it "adds the element to the collection" do
      @multiple.push(:something)
      expect(@multiple.size).to eq(1)
      @multiple.push(:something_else)
      expect(@multiple.size).to eq(2)
    end
  end
end

describe 'Group' do
  before do
    @micro_api = Prismic.api('https://micro.prismic.io/api', nil)
    @master_ref = @micro_api.master_ref
    @docchapter = @micro_api.form('everything').query('[[:d = at(document.type, "docchapter")]]').orderings('[my.docchapter.priority]').submit(@master_ref)[0]
    @link_resolver = Prismic.link_resolver('master'){|doc_link| "http://localhost/#{doc_link.type}/#{doc_link.id}" }
  end

  it 'accesses fields the proper way' do
    expect(@docchapter['docchapter.docs'][0]['linktodoc'].type).to eq('doc')
  end

  it 'serializes towards HTML as expected' do
    expect(@docchapter['docchapter.docs'].as_html(@link_resolver)).to eq("<section data-field=\"linktodoc\"><a href=\"http://localhost/doc/UrDofwEAALAdpbNH\">with-jquery</a></section>\n<section data-field=\"linktodoc\"><a href=\"http://localhost/doc/UrDp8AEAAPUdpbNL\">with-bootstrap</a></section>")
  end

  it 'loops through the group fragment properly' do
    expect(@docchapter['docchapter.docs']
           .map{ |fragments| fragments['linktodoc'].slug }
           .join(' ')).to eq("with-jquery with-bootstrap")
  end

  it 'returns the proper length of a group fragment' do
    expect(@docchapter['docchapter.docs'].length).to eq(2)
    expect(@docchapter['docchapter.docs'].size).to eq(2)
  end

  it 'loops through the subfragment list properly' do
    expect(@docchapter['docchapter.docs'][0].count).to eq(1)
    expect(@docchapter['docchapter.docs'][0].first[0]).to eq("linktodoc")
  end

  it 'returns the proper length of the sunfragment list' do
    expect(@docchapter['docchapter.docs'][0].length).to eq(1)
    expect(@docchapter['docchapter.docs'][0].size).to eq(1)
  end

end

describe 'Slices' do
  before do
    @raw_json_slices = File.read("#{File.dirname(__FILE__)}/responses_mocks/slices.json")
    @json_slices = JSON.load(@raw_json_slices)
    @doc = Prismic::JsonParser.document_parser(@json_slices)
    @slices = @doc.get_slice_zone("article.blocks")
    @link_resolver = Prismic.link_resolver('master'){|doc_link| "http://localhost/#{doc_link.type}/#{doc_link.id}" }
  end

  it 'parses correctly' do
    expect(@slices.as_text).to eq("\nc'est un bloc features\nC'est un bloc content\n")
    expect(@slices.as_html(@link_resolver).gsub('&#39;', "'")).to eq(%[<div data-slicetype="features" class="slice features-label"><section data-field="illustration"><img src="https://wroomdev.s3.amazonaws.com/toto/db3775edb44f9818c54baa72bbfc8d3d6394b6ef_hsf_evilsquall.jpg" alt="" width="4285" height="709" /></section>\n<section data-field="title"><span class="text">c'est un bloc features</span></section></div>\n<div data-slicetype="text" class="slice"><p>C'est un bloc content</p></div>\n<div data-slicetype="separator" class="slice"><section data-field="sep"><hr class="separator" /></section></div>])
  end

end
