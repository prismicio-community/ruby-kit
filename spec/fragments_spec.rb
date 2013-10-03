require 'spec_helper'

describe 'WebLink' do
  describe 'as_html' do
    before do
      @web_link = Prismic::Fragments::WebLink.new('my_url')
    end

    it "returns an <a> HTML element" do
      Nokogiri::XML(@web_link.as_html).child.name.should == 'a'
    end

    it "returns a HTML element with an href attribute" do
      Nokogiri::XML(@web_link.as_html).child.has_attribute?('href').should be_true
    end

    it "returns a HTML element with an href attribute pointing to the url" do
      Nokogiri::XML(@web_link.as_html).child.attribute('href').value.should == 'my_url'
    end

    it "returns a HTML element whose content is the link" do
      Nokogiri::XML(@web_link.as_html).child.content.should == 'my_url'
    end
  end
end

describe 'MediaLink' do
  describe 'as_html' do
    before do
      @media_link = Prismic::Fragments::MediaLink.new('my_url')
    end

    it "returns an <a> HTML element" do
      Nokogiri::XML(@media_link.as_html).child.name.should == 'a'
    end

    it "returns a HTML element with an href attribute" do
      Nokogiri::XML(@media_link.as_html).child.has_attribute?('href').should be_true
    end

    it "returns a HTML element with an href attribute pointing to the url" do
      Nokogiri::XML(@media_link.as_html).child.attribute('href').value.should == 'my_url'
    end

    it "returns a HTML element whose content is the link" do
      Nokogiri::XML(@media_link.as_html).child.content.should == 'my_url'
    end
  end
end

describe 'Text' do
  describe 'as_html' do
    before do
      @text = Prismic::Fragments::Text.new('my_value')
    end

    it "returns a <span> HTML element" do
      Nokogiri::XML(@text.as_html).child.name.should == 'span'
    end

    it "returns a HTML element with the 'text' class" do
      Nokogiri::XML(@text.as_html).child.attribute('class').value.split.should include 'text'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@text.as_html).child.content.should == 'my_value'
    end
  end
end

describe 'Select' do
  describe 'as_html' do
    before do
      @select = Prismic::Fragments::Select.new('my_value')
    end

    it "returns a <span> HTML element" do
      Nokogiri::XML(@select.as_html).child.name.should == 'span'
    end

    it "returns a HTML element with the 'text' class" do
      Nokogiri::XML(@select.as_html).child.attribute('class').value.split.should include 'text'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@select.as_html).child.content.should == 'my_value'
    end
  end
end

describe 'Date' do
  before do
    @date = Prismic::Fragments::Date.new(Time.new(2013, 8, 7, 11, 13, 7, '+02:00'))
  end

  describe 'as_html' do
    it "returns a <time> HTML element" do
      Nokogiri::XML(@date.as_html).child.name.should == 'time'
    end

    it "returns a HTML element whose content is the date in the ISO8601 format" do
      Nokogiri::XML(@date.as_html).child.content.should == '2013-08-07T11:13:07.000+02:00'
    end
  end
end

describe 'Number' do
  before do
    @number = Prismic::Fragments::Number.new(10.2)
  end

  describe 'as_int' do
    it "returns an Integer" do
      @number.as_int.should be_kind_of Integer
    end

    it "returns the integer representation of the number" do
      @number.as_int.should == 10
    end
  end

  describe 'as_html' do
    it "returns a <span> HTML element" do
      Nokogiri::XML(@number.as_html).child.name.should == 'span'
    end

    it "returns a HTML element with the class 'number'" do
      Nokogiri::XML(@number.as_html).child.attribute('class').value.split.should include 'number'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@number.as_html).child.content.should == 10.2.to_s
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
      @color.asRGB.should be_kind_of Hash
    end

    it "returns a hash of 3 elements" do
      @color.asRGB.size.should == 3
    end

    it "returns the correct red value" do
      @color.asRGB['red'].should == 0
    end

    it "returns the correct green value" do
      @color.asRGB['green'].should == 255
    end

    it "returns the correct blue value" do
      @color.asRGB['blue'].should == 153
    end
  end

  describe 'self.asRGB' do
    before do
      @color = Prismic::Fragments::Color
    end

    it "returns a hash" do
      @color.asRGB(@hex_value).should be_kind_of Hash
    end

    it "returns a hash of 3 elements" do
      @color.asRGB(@hex_value).size.should == 3
    end

    it "returns the correct red value" do
      @color.asRGB(@hex_value)['red'].should == 0
    end

    it "returns the correct green value" do
      @color.asRGB(@hex_value)['green'].should == 255
    end

    it "returns the correct blue value" do
      @color.asRGB(@hex_value)['blue'].should == 153
    end
  end

  describe 'as_html' do
    it "returns a <span> HTML element" do
      Nokogiri::XML(@color.as_html).child.name.should == 'span'
    end

    it "returns a HTML element with the class 'color'" do
      Nokogiri::XML(@color.as_html).child.attribute('class').value.split.should include 'color'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@color.as_html).child.content.should == "##@hex_value"
    end
  end

  describe 'self.valid?' do
    it "returns true if the color is valid" do
      Prismic::Fragments::Color.valid?(@hex_value).should be_true
    end

    it "returns false if the color is not valid" do
      Prismic::Fragments::Color.valid?("I'm a murloc").should be_false
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
      Nokogiri::XML(@embed.as_html).child.name.should == 'div'
    end

    it "returns an element with a data-oembed attribute" do
      Nokogiri::XML(@embed.as_html).child.has_attribute?('data-oembed').should be_true
    end

    it "returns an element with a data-oembed attribute containing the url" do
      Nokogiri::XML(@embed.as_html).child.attribute('data-oembed').value.should == 'my_url'
    end

    it "returns an element with a data-oembed-type attribute" do
      Nokogiri::XML(@embed.as_html).child.has_attribute?('data-oembed-type').should be_true
    end

    it "returns an element with a data-oembed-type attribute containing the type in lowercase" do
      Nokogiri::XML(@embed.as_html).child.attribute('data-oembed-type').value.should == 'my_type'
    end

    it "returns an element with a data-oembed-provider attribute" do
      Nokogiri::XML(@embed.as_html).child.has_attribute?('data-oembed-provider').should be_true
    end

    it "returns an element with a data-oembed-provider attribute containing the provider in lowercase" do
      Nokogiri::XML(@embed.as_html).child.attribute('data-oembed-provider').value.should == 'my_provider'
    end

    it "returns an element wrapping the `html` value" do
      Nokogiri::XML(@embed.as_html).child.content.should == 'my_html'
    end
  end
end

describe 'Image::View' do
  before do
    @url = 'my_url'
    @width = 10
    @height = 2
    @view = Prismic::Fragments::Image::View.new(@url, @width, @height)
  end

  describe 'ratio' do
    it "returns the width/height ratio of the image" do
      @view.ratio.should == @width / @height
    end
  end

  describe 'as_html' do
    it "return an <img> HTML element" do
      Nokogiri::XML(@view.as_html).child.name.should == 'img'
    end

    it "returns an element whose `src` attribute equals the url" do
      Nokogiri::XML(@view.as_html).child.attribute('src').value.should == @url
    end

    it "returns an element whose `width` attribute equals the width" do
      Nokogiri::XML(@view.as_html).child.attribute('width').value.should == @width.to_s
    end

    it "returns an element whose `height` attribute equals the height" do
      Nokogiri::XML(@view.as_html).child.attribute('height').value.should == @height.to_s
    end
  end
end

describe 'Image' do
  before do
    @main_view = Prismic::Fragments::Image::View.new('my_url', 10, 10)
    @another_view = Prismic::Fragments::Image::View.new('my_url2', 20, 20)
    @image = Prismic::Fragments::Image.new(@main_view, { 'another_view' => @another_view })
  end

  describe 'get_view' do
    it "returns `main`'s value is asked for`" do
      @image.get_view('main').should == @main_view
    end

    it "returns the value of the specified key" do
      @image.get_view('another_view').should == @another_view
    end

    it "raises an error if the key does not exist" do
      expect { @image.get_view('foo') }.to raise_error Prismic::Fragments::Image::ViewDoesNotExistException
    end
  end

  describe 'as_html' do
    it "returns the HTML representation of the main view" do
      Nokogiri::XML(@image.as_html).child.name.should == Nokogiri::XML(@main_view.as_html).child.name
      Nokogiri::XML(@image.as_html).child.attribute('src').value.should == Nokogiri::XML(@main_view.as_html).child.attribute('src').value
      Nokogiri::XML(@image.as_html).child.attribute('width').value.should == Nokogiri::XML(@main_view.as_html).child.attribute('width').value
      Nokogiri::XML(@image.as_html).child.attribute('height').value.should == Nokogiri::XML(@main_view.as_html).child.attribute('height').value
    end
  end
end

describe 'StructuredText::Image' do
  before do
    @view = Prismic::Fragments::Image::View.new('my_url', 10, 10)
    @image = Prismic::Fragments::StructuredText::Block::Image.new(@view)
  end

  describe 'url' do
    it "returns the view's url" do
      @image.url.should == @view.url
    end
  end

  describe 'width' do
    it "returns the view's width" do
      @image.width.should == @view.width
    end
  end

  describe 'height' do
    it "returns the view's height" do
      @image.height.should == @view.height
    end
  end
end

describe 'StructuredText::Span' do
  describe 'as_html'
end

describe 'StructuredText::Hyperlink' do
  before do
    @link = Prismic::Fragments::DocumentLink.new(
      "UdUjvt_mqVNObPeO",
      "product",
      ["Macaron"],
      "dark-chocolate-macaron",
      false  # broken
    )
    @hyperlink = Prismic::Fragments::StructuredText::Span::Hyperlink.new(0, 0, @link)
    @link_resolver = Prismic.link_resolver("master"){|doc_link| "http://localhost/#{doc_link.id}" }
  end

  describe 'as_html' do
    it "can generate valid link" do
      @hyperlink.start_html(@link_resolver).should == '<a href="http://localhost/UdUjvt_mqVNObPeO">'
    end
    it "can generate valid html for broken link" do
      @link.broken = true
      @hyperlink.start_html(@link_resolver).should == "<span>"
    end
  end
end

describe 'DocumentLink' do
  describe 'as_html'
end

describe 'Multiple' do
  before do
    @multiple = Prismic::Fragments::Multiple.new
  end

  describe 'push' do
    it "adds the element to the collection" do
      @multiple.push(:something)
      @multiple.size.should == 1
      @multiple.push(:something_else)
      @multiple.size.should == 2
    end
  end
end
