require 'spec_helper'

describe 'Api' do
  before do
    json_representation = '{"foo": "bar"}'
    @master = Prismic::Ref.new('ref3', 'label3', true)
    @api = Prismic::API.new(json_representation) { |api|
      api.refs = {
        'key1' => Prismic::Ref.new('ref1', 'label1'),
        'key2' => Prismic::Ref.new('ref2', 'label2'),
        'key3' => @master,
        'key4' => Prismic::Ref.new('ref4', 'label4'),
      }
      api.forms = {
        'form1' => Prismic::SearchForm.new(api, Prismic::Form.new('form1', {}, nil, nil, nil, nil)),
        'form2' => Prismic::SearchForm.new(api, Prismic::Form.new('form2', {}, nil, nil, nil, nil)),
        'form3' => Prismic::SearchForm.new(api, Prismic::Form.new('form3', {}, nil, nil, nil, nil)),
        'form4' => Prismic::SearchForm.new(api, Prismic::Form.new('form4', {}, nil, nil, nil, nil)),
      }
      api.master = @master
    }
  end

  describe 'ref' do
    it "returns the right Ref" do
      @api.ref('key2').label.should == 'label2'
    end
  end

  describe 'refs' do
    it "returns the correct number of elements" do
      @api.refs.size.should == 4
    end
  end

  describe 'ref_id_by_label' do
    it "returns the id of the ref" do
      @api.ref_id_by_label('key4').ref == 'ref4'
    end
  end

  describe 'form' do
    it "return the right Form" do
      @api.form('form2').form.name.should == 'form2'
    end
  end

  describe 'forms' do
    it "returns the correct number of elements" do
      @api.forms.size.should == 4
    end
  end

  describe 'master' do
    it "returns a master Ref" do
      @api.master.master?.should be_true
    end
  end

  describe 'parse_api_response' do
    before do
      @data = File.read("#{File.dirname(__FILE__)}/responses_mocks/api.json")
      @json = Yajl::Parser.new.parse(@data)
      @parsed = Prismic::API.parse_api_response(@json)
    end

    it "does not allow to be created without master Ref" do
      expect {
        Prismic::API.parse_api_response({
          "refs" => [],
        })
      }.to raise_error(Prismic::API::BadPrismicResponseError, "No master Ref found")
    end

    it "does not allow to be created without any Ref" do
      expect {
        Prismic::API.parse_api_response({})
      }.to raise_error(Prismic::API::BadPrismicResponseError, "No refs given")
    end

    it "creates 2 refs" do
      @parsed.refs.size.should == 2
    end

    it "creates the right ref's ref" do
      @parsed.refs['bar'].ref.should == 'foo'
    end

    it "creates the right ref's label" do
      @parsed.refs['bar'].label.should == 'bar'
    end

    it "creates the right ref's 'master' value" do
      @parsed.refs['bar'].master?.should == false
    end

    it "creates 3 bookmarks" do
      @parsed.bookmarks.size.should == 3
    end

    it "creates the right bookmarks" do
      @parsed.bookmarks['about'].should == 'Ue0EDd_mqb8Dhk3j'
    end

    it "creates 6 types" do
      @parsed.types.size.should == 6
    end

    it "creates the right types" do
      @parsed.types['blog-post'].should == 'Blog post'
    end

    it "creates 4 tags" do
      @parsed.tags.size.should == 4
    end

    it "creates the right tags" do
      @parsed.tags.should include 'Cupcake'
    end

    it "creates 10 forms" do
      @parsed.forms.size.should == 10
    end

    it "creates the right form's name" do
      @parsed.forms['pies'].name.should == 'Little Pies'
    end

    it "creates the right form's method" do
      @parsed.forms['pies'].form_method.should == 'GET'
    end

    it "creates the right form's rel" do
      @parsed.forms['pies'].rel.should == 'collection'
    end

    it "creates the right form's enctype" do
      @parsed.forms['pies'].enctype.should == 'application/x-www-form-urlencoded'
    end

    it "creates the right form's action" do
      @parsed.forms['pies'].action.should == 'http://lesbonneschoses.wroom.io/api/documents/search'
    end

    it "creates forms with the right fields" do
      @parsed.forms['pies'].fields.size.should == 2
    end

    it "creates forms with the right type info" do
      @parsed.forms['pies'].fields['ref'].field_type.should == 'String'
    end

    it "creates forms with the right default info" do
      @parsed.forms['pies'].fields['q'].default.should ==
        '[[at(document.tags, ["Pie"])][any(document.type, ["product"])]]'
    end
  end

  describe 'as_json' do
    before do
      @json = @api.as_json
    end

    it "returns the json representation of the api" do
      JSON.parse(@json)['foo'].should == 'bar'
    end

    it "returns the json representation of the api containing one single element" do
      JSON.parse(@json).size.should == 1
    end
  end
end
