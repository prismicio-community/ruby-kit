require 'spec_helper'

describe 'Api' do
  before do
    json_representation = '{"foo": "bar"}'
    @oauth_initiate_url = "https://lesbonneschoses.prismic.io/auth"
    @api = Prismic::API.new(json_representation){|api|
      api.bookmarks = {}
      api.tags = {}
      api.types = {}
      api.refs = {
        'key1' => Prismic::Ref.new('ref1', 'label1'),
        'key2' => Prismic::Ref.new('ref2', 'label2'),
        'key3' => Prismic::Ref.new('ref3', 'label3', true),
        'key4' => Prismic::Ref.new('ref4', 'label4'),
      }
      api.forms = {
        'form1' => Prismic::Form.new(@api, 'form1', {}, nil, nil, nil, nil),
        'form2' => Prismic::Form.new(@api, 'form2', {}, nil, nil, nil, nil),
        'form3' => Prismic::Form.new(@api, 'form3', {}, nil, nil, nil, nil),
        'form4' => Prismic::Form.new(@api, 'form4', {}, nil, nil, nil, nil),
      }
      api.oauth =  Prismic::API::OAuth.new(@oauth_initiate_url, "https://lesbonneschoses.prismic.io/auth/token")
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
      @api.ref('key4').ref == 'ref4'
    end
  end

  describe 'form' do
    it "return the right Form" do
      @api.form('form2').name.should == 'form2'
    end
  end

  describe 'create_search_form' do
    it "create a new search form for the right form" do
      @form = @api.create_search_form('form2')
      @form.form.name.should == 'form2'
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
      @json = JSON.parse(@data)
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
      @parsed.forms['pies'].action.should == 'http://lesbonneschoses.prismic.io/api/documents/search'
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

  describe "oauth_initiate_url" do
    before do
      @client_id = "client_id"
      @redirect_uri = "http://website/callback"
      @scope = "none"
    end
    def oauth_initiate_url
      @api.oauth_initiate_url({
        client_id: @client_id,
        redirect_uri: @redirect_uri,
        scope: @scope,
      })
    end
    def redirect_uri_encoded
      CGI.escape(@redirect_uri)
    end
    it "build a valid url" do
      oauth_initiate_url.should == "#@oauth_initiate_url?client_id=#@client_id&redirect_uri=#{redirect_uri_encoded}&scope=#@scope"
    end
  end

end

describe 'Document' do
  before do
    fragments = {
      'field1' => Prismic::Fragments::DocumentLink.new(nil, nil, nil, nil, nil),
      'field2' => Prismic::Fragments::WebLink.new('weburl')
    }
    @document = Prismic::Document.new(nil, nil, nil, nil, ['my-slug'], fragments)
    @link_resolver = Prismic::LinkResolver.new('master'){|doc_link|
      "http://host/#{doc_link.id}"
    }
  end

  describe 'slug' do
    it "returns the first slug if found" do
      @document.slug.should == 'my-slug'
    end

    it "returns '-' if no slug found" do
      @document.slugs = []
      @document.slug.should == '-'
    end
  end

  describe 'as_html' do
    it "returns a <section> HTML element" do
      Nokogiri::XML(@document.as_html(@link_resolver)).child.name.should == 'section'
    end

    it "returns a HTML element with a 'data-field' attribute" do
      Nokogiri::XML(@document.as_html(@link_resolver)).child.has_attribute?('data-field').should be_true
    end

    it "returns a HTML element with a 'data-field' attribute containing the name of the field" do
      Nokogiri::XML(@document.as_html(@link_resolver)).child.attribute('data-field').value.should == 'field1'
    end
  end
end

describe 'SearchForm' do
  before do
    @field = Prismic::Field.new('String', ['foo'], true)
    @api = nil
  end

  def create_form(fields)
    form = Prismic::Form.new(nil, 'form1', fields, nil, nil, nil, nil)
    form.create_search_form
  end

  describe 'set() for queries' do

    it "append value for repetable fields" do
      @field = Prismic::Field.new('String', ['foo'], true)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      @form.data.should == { 'q' => ['foo', 'bar'] }  # test the 1st call
      @form.set('q', 'baz')
      @form.data.should == { 'q' => ['foo', 'bar', 'baz'] }  # test an other
    end

    it "replace value for non repetable fields" do
      @field = Prismic::Field.new('String', 'foo', false)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      @form.data.should == { 'q' => 'bar' }  # test the 1st call
      @form.set('q', 'baz')
      @form.data.should == { 'q' => 'baz' }  # test an other
    end

    it "create value array for repetable fields without value" do
      @field = Prismic::Field.new('String', nil, true)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      @form.data.should == { 'q' => ['bar'] }
    end

    it "create value for non repetable fields without value" do
      @field = Prismic::Field.new('String', nil, false)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      @form.data.should == { 'q' => 'bar' }
    end

    it "returns the form itself" do
      @form = create_form('q' => @field)
      @form.query('foo').should equal @form
    end

    it "merge user defined params into default ones" do
      field = ->(value){ Prismic::Field.new('String', value) }
      default_params = {'param1' => field.('a'), 'param2' => field.('b')}
      @form = create_form(default_params)
      @form.set('param1', 'a2')
      @form.data.should == {'param1' => 'a2', 'param2' => 'b'}
    end
  end

  describe 'submit' do
    it "raises an exception if no ref is set" do
      @form = create_form('q' => @field)
      expect { @form.submit }.to raise_error Prismic::SearchForm::NoRefSetException
    end
  end
end
