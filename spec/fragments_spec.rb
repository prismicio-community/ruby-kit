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
