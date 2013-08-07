require 'spec_helper'

describe 'WebLink' do
  describe 'asHtml' do
    before do
      @web_link = Fragments::WebLink.new('my_url')
    end

    it "returns an <a> HTML element" do
      Nokogiri::XML(@web_link.asHtml).child.name.should == 'a'
    end

    it "returns a HTML element with an href attribute" do
      Nokogiri::XML(@web_link.asHtml).child.has_attribute?('href').should be_true
    end

    it "returns a HTML element with an href attribute pointing to the url" do
      Nokogiri::XML(@web_link.asHtml).child.attribute('href').value.should == 'my_url'
    end

    it "returns a HTML element whose content is the link" do
      Nokogiri::XML(@web_link.asHtml).child.content.should == 'my_url'
    end
  end
end

describe 'MediaLink' do
  describe 'asHtml' do
    before do
      @media_link = Fragments::MediaLink.new('my_url')
    end

    it "returns an <a> HTML element" do
      Nokogiri::XML(@media_link.asHtml).child.name.should == 'a'
    end

    it "returns a HTML element with an href attribute" do
      Nokogiri::XML(@media_link.asHtml).child.has_attribute?('href').should be_true
    end

    it "returns a HTML element with an href attribute pointing to the url" do
      Nokogiri::XML(@media_link.asHtml).child.attribute('href').value.should == 'my_url'
    end

    it "returns a HTML element whose content is the link" do
      Nokogiri::XML(@media_link.asHtml).child.content.should == 'my_url'
    end
  end
end

describe 'Text' do
  describe 'asHtml' do
    before do
      @text = Fragments::Text.new('my_value')
    end

    it "returns a <span> HTML element" do
      Nokogiri::XML(@text.asHtml).child.name.should == 'span'
    end

    it "returns a HTML element with the 'text' class" do
      Nokogiri::XML(@text.asHtml).child.attribute('class').value.split.should include 'text'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@text.asHtml).child.content.should == 'my_value'
    end
  end
end

describe 'Date' do
  before do
    @date = Fragments::Date.new(DateTime.new(2013, 8, 7, 11, 13, 7, '+2'))
  end

  describe 'asHtml' do
    it "returns a <time> HTML element" do
      Nokogiri::XML(@date.asHtml).child.name.should == 'time'
    end

    it "returns a HTML element whose content is the date in the ISO8601 format" do
      Nokogiri::XML(@date.asHtml).child.content.should == '2013-08-07T11:13:07.000+02:00'
    end
  end
end

describe 'Number' do
  before do
    @number = Fragments::Number.new(10.2)
  end

  describe 'asInt' do
    it "returns an Integer" do
      @number.asInt.should be_kind_of Integer
    end

    it "returns the integer representation of the number" do
      @number.asInt.should == 10
    end
  end

  describe 'asHtml' do
    it "returns a <span> HTML element" do
      Nokogiri::XML(@number.asHtml).child.name.should == 'span'
    end

    it "returns a HTML element with the class 'number'" do
      Nokogiri::XML(@number.asHtml).child.attribute('class').value.split.should include 'number'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@number.asHtml).child.content.should == '10.2'
    end
  end
end

describe 'Color' do
  before do
    @hex_value = '00FF99'
    @color = Fragments::Color.new(@hex_value)
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
      @color = Fragments::Color
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

  describe 'asHtml' do
    it "returns a <span> HTML element" do
      Nokogiri::XML(@color.asHtml).child.name.should == 'span'
    end

    it "returns a HTML element with the class 'color'" do
      Nokogiri::XML(@color.asHtml).child.attribute('class').value.split.should include 'color'
    end

    it "returns a HTML element whose content is the value" do
      Nokogiri::XML(@color.asHtml).child.content.should == @hex_value
    end
  end

  describe 'self.is_a_valid_color' do
    it "returns true if the color is valid" do
      Fragments::Color.is_a_valid_color(@hex_value).should be_true
    end

    it "returns false if the color is not valid" do
      Fragments::Color.is_a_valid_color("I'm a murloc").should be_false
    end
  end
end

describe 'Embed' do
  before do
    @embed = Fragments::Embed.new('MY_TYPE', 'MY_PROVIDER', 'my_url', 'my_width',
                                  'my_height', 'my_html', 'my_oembed_json')
  end

  describe 'asHtml' do
    it "returns a div element" do
      Nokogiri::XML(@embed.asHtml).child.name.should == 'div'
    end

    it "returns an element with a data-oembed attribute" do
      Nokogiri::XML(@embed.asHtml).child.has_attribute?('data-oembed').should be_true
    end

    it "returns an element with a data-oembed attribute containing the url" do
      Nokogiri::XML(@embed.asHtml).child.attribute('data-oembed').value.should == 'my_url'
    end

    it "returns an element with a data-oembed-type attribute" do
      Nokogiri::XML(@embed.asHtml).child.has_attribute?('data-oembed-type').should be_true
    end

    it "returns an element with a data-oembed-type attribute containing the type in lowercase" do
      Nokogiri::XML(@embed.asHtml).child.attribute('data-oembed-type').value.should == 'my_type'
    end

    it "returns an element with a data-oembed-provider attribute" do
      Nokogiri::XML(@embed.asHtml).child.has_attribute?('data-oembed-provider').should be_true
    end

    it "returns an element with a data-oembed-provider attribute containing the provider in lowercase" do
      Nokogiri::XML(@embed.asHtml).child.attribute('data-oembed-provider').value.should == 'my_provider'
    end

    it "returns an element wrapping the `html` value" do
      Nokogiri::XML(@embed.asHtml).child.content.should == 'my_html'
    end
  end
end
