require 'spec_helper'

describe 'Api' do
  before do
    @data = {}
    @data['refs'] = [
      Ref.new('ref1', 'label1'),
      Ref.new('ref2', 'label2'),
      Ref.new('ref30', 'label3'),
      Ref.new('ref3', 'label3', true),
      Ref.new('ref4', 'label4'),
    ]
    @data['forms'] = {
      'form1' => Form.new('form1'),
      'form2' => Form.new('form2'),
      'form3' => Form.new('form3'),
      'form4' => Form.new('form4'),
    }
    @api = Api.new(@data)
  end

  describe 'refs' do
    it "returns a map with an element from each type" do
      @api.refs['label2'].ref.should == 'ref2'
    end

    it "returns a map with the correct number of elements" do
      @api.refs.size.should == 4
    end
  end

  describe 'forms' do
    it "returns a map of { String => SearchForm }" do
      @api.forms['form1'].should be_kind_of (SearchForm)
    end

    it "sets SearchForm.api to the correct value" do
      @api.forms['form2'].api.should be_kind_of (Api)
    end

    it "sets SearchForm.form to the correct value" do
      @api.forms['form2'].form.name.should == 'form2'
    end

    it "sets SearchForm.data to the correct value" do
      @api.forms['form2'].data.should == {}
    end

    it "returns a map with the correct number of elements" do
      @api.forms.size.should == 4
    end
  end

  describe 'master' do
    it "returns a Ref" do
      @api.master.should be_kind_of (Ref)
    end

    it "returns the first master" do
      @api.master.label.should == 'label3'
    end

    it "throws an exception if no master was found" do
      expect { Api.new({ 'refs' => [] }) }.to raise_error Api::NoMasterFoundException
    end
  end

  describe 'parse_api_response' do
    before do
      data = File.open("#{Dir.pwd}/spec/responses_mocks/api.json").read
      @parsed_response = Api.parse_api_response(data)
    end

    describe "parsing refs" do
      it "returns a hash" do
        @parsed_response.should be_kind_of Hash
      end

      it "returns a hash containing a an array" do
        @parsed_response['refs'].should be_kind_of Array
      end

      it "returns a hash containing a an array whose size is 2" do
        @parsed_response['refs'].size.should == 2
      end

      it "returns a hash containing a an array of Ref objects" do
        @parsed_response['refs'][0].should be_kind_of Ref
      end

      it "fills the Ref objects with the correct data" do
        @parsed_response['refs'][1].ref.should == 'foo'
        @parsed_response['refs'][1].label.should == 'bar'
        @parsed_response['refs'][1].isMasterRef.should == false
      end
    end
  end
end

describe 'Form' do
  describe 'defaultData' do
    it 'creates a map of default fields data' do
      form = Form.new

      form.fields = {"foo1" => nil}
      defaultData = form.defaultData
      defaultData.should be_empty

      form = Form.new
      form.fields = {"foo1" => "bar1",
                     "foo2" => "bar2",
                     "foo3" => nil,
                     "foo4" => "bar4"}
      defaultData = form.defaultData
      defaultData.size.should == 3
    end
  end
end
