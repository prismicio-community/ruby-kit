require 'spec_helper'

describe 'WebLink' do
  describe 'asHtml' do
    it "returns an <a> HTML tag pointing to the link" do
      web_link = Fragments::WebLink.new('my_url')
      web_link.asHtml.should == '<a href="my_url">my_url</a>'
    end
  end
end

describe 'MediaLink' do
  describe 'asHtml' do
    it "returns an <a> HTML tag pointing to the link" do
      media_link = Fragments::MediaLink.new('my_url')
      media_link.asHtml.should == '<a href="my_url">my_url</a>'
    end
  end
end

describe 'Text' do
  describe 'asHtml' do
    it "returns a <span> HTML tag with class 'text' that wraps the value" do
      text = Fragments::Text.new('my_value')
      text.asHtml.should == '<span class="text">my_value</span>'
    end
  end
end

describe 'Text' do
  describe 'asHtml' do
    it "returns a <span> HTML tag with class 'text' that wraps the value" do
      text = Fragments::Text.new('my_value')
      text.asHtml.should == '<span class="text">my_value</span>'
    end
  end
end

describe 'Date' do
  describe 'asHtml' do
    it "returns a <time> HTML tag that wraps the date in the ISO8601 format" do
      text = Fragments::Date.new(DateTime.new(2013, 8, 7, 11, 13, 7, '+2'))
      text.asHtml.should == '<time>2013-08-07T11:13:07.000+02:00</time>'
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
    it "returns a <span> HTML tag with the class 'number' that wraps the value" do
      @number.asHtml.should == "<span class=\"number\">10.2</span>"
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
    it "returns a <span> HTML tag with the class 'color' and wrapping the value" do
      @color.asHtml.should == "<span class=\"color\">#{@hex_value}</span>"
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

    it "returns a div element with a data-oembed attribute" do
      Nokogiri::XML(@embed.asHtml).child.has_attribute?('data-oembed').should be_true
    end

    it "returns a div element with a data-oembed attribute containing the url" do
      Nokogiri::XML(@embed.asHtml).child.attribute('data-oembed').value.should == 'my_url'
    end

    it "returns a div element with a data-oembed-type attribute" do
      Nokogiri::XML(@embed.asHtml).child.has_attribute?('data-oembed-type').should be_true
    end

    it "returns a div element with a data-oembed-type attribute containing the type in lowercase" do
      Nokogiri::XML(@embed.asHtml).child.attribute('data-oembed-type').value.should == 'my_type'
    end

    it "returns a div element with a data-oembed-provider attribute" do
      Nokogiri::XML(@embed.asHtml).child.has_attribute?('data-oembed-provider').should be_true
    end

    it "returns a div element with a data-oembed-provider attribute containing the provider in lowercase" do
      Nokogiri::XML(@embed.asHtml).child.attribute('data-oembed-provider').value.should == 'my_provider'
    end

    it "returns a div element wrapping the `html` value" do
      Nokogiri::XML(@embed.asHtml).child.content.should == 'my_html'
    end
  end
end
