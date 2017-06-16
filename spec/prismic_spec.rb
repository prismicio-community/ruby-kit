# encoding: utf-8
require 'spec_helper'

describe 'Api' do
  before do
    json_representation = '{"foo": "bar"}'
    @oauth_initiate_url = 'https://micro.prismic.io/auth'
    @api = Prismic::API.new(json_representation, nil, Prismic::DefaultHTTPClient, false){|api|
      api.bookmarks = {}
      api.tags = {}
      api.types = {}
      api.refs = {
        'key1' => Prismic::Ref.new('id1', 'ref1', 'label1'),
        'key2' => Prismic::Ref.new('id2', 'ref2', 'label2'),
        'key3' => Prismic::Ref.new('id3', 'ref3', 'label3', true),
        'key4' => Prismic::Ref.new('id4', 'ref4', 'label4'),
      }
      api.forms = {
        'form1' => Prismic::Form.new(@api, 'form1', {}, nil, nil, nil, nil),
        'form2' => Prismic::Form.new(@api, 'form2', {
          'q' => Prismic::Field.new('string', '[[any(document.type, [\"product\"])]]', true),
          'param1' => Prismic::Field.new('string', 'value1', false),
        }, nil, nil, nil, nil),
        'form3' => Prismic::Form.new(@api, 'form3', {}, nil, nil, nil, nil),
        'form4' => Prismic::Form.new(@api, 'form4', {}, nil, nil, nil, nil),
      }
      api.oauth =  Prismic::API::OAuth.new(@oauth_initiate_url, 'https://micro.prismic.io/auth/token', Prismic::DefaultHTTPClient)
    }
  end

  describe 'errors' do
    it 'is correct when passing a nil URL' do
      expect { Prismic.api(nil) }.to raise_error ArgumentError
    end
    it 'is correct when passing a wrong URL' do
      expect { Prismic.api("foobar") }.to raise_error ArgumentError
    end
  end

  describe 'id' do
    it 'returns the right id' do
      expect(@api.ref('key1').id).to eq('id1')
    end
  end

  describe 'ref' do
    it 'returns the right Ref' do
      expect(@api.ref('key2').label).to eq('label2')
    end
  end

  describe 'refs' do
    it 'returns the correct number of elements' do
      expect(@api.refs.size).to eq(4)
    end
  end

  describe 'ref_id_by_label' do
    it 'returns the id of the ref' do
      @api.ref('key4').ref == 'ref4'
    end
  end

  describe 'master_ref' do
    it 'returns the right Ref' do
      expect(@api.master_ref.label).to eq('label3')
    end
  end

  describe 'master' do
    it 'returns the right Ref' do
      expect(@api.master.label).to eq('label3')
    end
  end

  describe 'forms' do
    it 'return the right Form' do
      expect(@api.forms['form2'].name).to eq('form2')
    end
  end

  describe 'create_search_form' do
    it 'create a new search form for the right form' do
      @form = @api.form('form2')
      expect(@form.form.name).to eq('form2')
    end
    it 'store default value as simple value when the field is not repeatable' do
      @form = @api.form('form2')
      expect(@form.data['param1']).to eq('value1')
    end
    it 'store default value as array when the field is repeatable' do
      @form = @api.form('form2')
      expect(@form.data['q']).to eq(['[[any(document.type, [\"product\"])]]'])
    end
  end

  describe 'deprecated create_search_form' do
    it 'create a new search form for the right form' do
      expect(@api).to receive(:warn).with('[DEPRECATION] `create_search_form` is deprecated.  Please use `form` instead.')
      @form = @api.create_search_form('form2')
      expect(@form.form.name).to eq('form2')
    end
    it 'store default value as simple value when the field is not repeatable' do
      @form = @api.create_search_form('form2')
      expect(@form.data['param1']).to eq('value1')
    end
    it 'store default value as array when the field is repeatable' do
      @form = @api.create_search_form('form2')
      expect(@form.data['q']).to eq(['[[any(document.type, [\"product\"])]]'])
    end
  end

  describe 'forms' do
    it 'returns the correct number of elements' do
      expect(@api.forms.size).to eq(4)
    end
  end

  describe 'master' do
    it 'returns a master Ref' do
      expect(@api.master.master?).to be(true)
    end
  end

  describe 'parse_api_response' do
    before do
      @data = File.read("#{File.dirname(__FILE__)}/responses_mocks/api.json")
      @json = JSON.load(@data)
      @parsed = Prismic::API.parse_api_response(@json, nil, Prismic::DefaultHTTPClient, false)
    end

    it 'does not allow to be created without master Ref' do
      expect {
        Prismic::API.parse_api_response({'refs' => []}, nil, Prismic::DefaultHTTPClient, false)
      }.to raise_error(Prismic::API::BadPrismicResponseError, 'No master Ref found')
    end

    it 'does not allow to be created without any Ref' do
      expect {
        Prismic::API.parse_api_response({}, nil, Prismic::DefaultHTTPClient, false)
      }.to raise_error(Prismic::API::BadPrismicResponseError, 'No refs given')
    end

    it 'creates 2 refs' do
      expect(@parsed.refs.size).to eq(2)
    end

    it "creates the right ref's ref" do
      expect(@parsed.refs['bar'].ref).to eq('foo')
    end

    it "creates the right ref's label" do
      expect(@parsed.refs['bar'].label).to eq('bar')
    end

    it "creates the right ref's 'master' value" do
      expect(@parsed.refs['bar'].master?).to be(false)
    end

    it 'creates 3 bookmarks' do
      expect(@parsed.bookmarks.size).to eq(3)
    end

    it 'creates the right bookmarks' do
      expect(@parsed.bookmarks['about']).to eq('Ue0EDd_mqb8Dhk3j')
    end

    it 'creates 6 types' do
      expect(@parsed.types.size).to eq(6)
    end

    it 'creates the right types' do
      expect(@parsed.types['blog-post']).to eq('Blog post')
    end

    it 'creates 4 tags' do
      expect(@parsed.tags.size).to eq(4)
    end

    it 'creates the right tags' do
      expect(@parsed.tags).to include('Cupcake')
    end

    it 'creates 10 forms' do
      expect(@parsed.forms.size).to eq(10)
    end

    it "creates the right form's name" do
      expect(@parsed.forms['pies'].name).to eq('Little Pies')
    end

    it "creates the right form's method" do
      expect(@parsed.forms['pies'].form_method).to eq('GET')
    end

    it "creates the right form's rel" do
      expect(@parsed.forms['pies'].rel).to eq('collection')
    end

    it "creates the right form's enctype" do
      expect(@parsed.forms['pies'].enctype).to eq('application/x-www-form-urlencoded')
    end

    it "creates the right form's action" do
      expect(@parsed.forms['pies'].action).to eq('http://micro.prismic.io/api/documents/search')
    end

    it 'creates forms with the right fields' do
      expect(@parsed.forms['pies'].fields.size).to eq(2)
    end

    it 'creates forms with the right type info' do
      expect(@parsed.forms['pies'].fields['ref'].field_type).to eq('String')
    end

    it 'creates forms with the right default info' do
      expect(@parsed.forms['pies'].fields['q'].default).to eq(        '[[at(document.tags, ["Pie"])][any(document.type, ["product"])]]')
    end

    it "create fields (other than 'q') as non repeatable" do
      expect(@parsed.forms['pies'].fields['ref'].repeatable).to be(false)
    end

    it "create 'q' fields as repeatable" do
      expect(@parsed.forms['pies'].fields['q'].repeatable).to be(true)
    end

  end

  describe 'as_json' do
    before do
      @json = @api.as_json
    end

    it 'returns the json representation of the api' do
      expect(JSON.load(@json)['foo']).to eq('bar')
    end

    it 'returns the json representation of the api containing one single element' do
      expect(JSON.load(@json).size).to eq(1)
    end
  end

  describe 'oauth_initiate_url' do
    before do
      @client_id = 'client_id'
      @redirect_uri = 'http://website/callback'
      @scope = 'none'
    end
    def oauth_initiate_url
      Prismic.oauth_initiate_url('https://micro.prismic.io/api', {
        client_id: @client_id,
        redirect_uri: @redirect_uri,
        scope: @scope
      })
    end
    def redirect_uri_encoded
      CGI.escape(@redirect_uri)
    end
    it 'build a valid url' do
      expect(oauth_initiate_url).to eq("https://micro.prismic.io/auth?client_id=#@client_id&redirect_uri=#{redirect_uri_encoded}&scope=#@scope")
    end
  end

end

describe 'LinkResolver' do
  before do
    @doc_link = Prismic::Fragments::DocumentLink.new('id', nil, 'blog-post', ['tag1', 'tag2'], 'my-slug', "fr-fr", {}, false)
    @document = Prismic::Document.new('id', nil, 'blog-post', nil, ['tag1', 'tag2'], ['my-slug', 'my-other-slug'], nil, nil, "en-us", nil, nil)

    @link_resolver = Prismic::LinkResolver.new(nil) do |doc|
      '/'+doc.lang+'/'+doc.type+'/'+doc.id+'/'+doc.slug
    end
  end

  it 'builds the right URL from a DocumentLink' do
    expect(@link_resolver.link_to(@doc_link)).to eq('/fr-fr/blog-post/id/my-slug')
  end

  it 'builds the right URL from a Document' do
    expect(@link_resolver.link_to(@document)).to eq('/en-us/blog-post/id/my-slug')
  end
end

describe 'Document' do
  before do
    fragments = {
      'field1' => Prismic::Fragments::DocumentLink.new(nil, nil, nil, nil, nil, "fr-fr", {}, nil),
      'field2' => Prismic::Fragments::WebLink.new('weburl')
    }
    @document = Prismic::Document.new(nil, nil, nil, nil, nil, ['my-slug'], nil, nil, "fr-fr", nil, fragments)
    @link_resolver = Prismic::LinkResolver.new('master'){|doc_link|
      "http://host/#{doc_link.id}"
    }
  end

  describe 'first_title' do
    it 'returns the right title' do
      @document.fragments['field3'] = Prismic::Fragments::StructuredText.new([
        Prismic::Fragments::StructuredText::Block::Text.new('This is not a title', []),
        Prismic::Fragments::StructuredText::Block::Heading.new('This is a title, but not the highest', [], 3),
        Prismic::Fragments::StructuredText::Block::Heading.new('This is the highest title of the fragment, but not the document', [], 2),
        Prismic::Fragments::StructuredText::Block::Text.new('This is not a title', [])
      ])
      @document.fragments['field4'] = Prismic::Fragments::StructuredText.new([
        Prismic::Fragments::StructuredText::Block::Text.new('This is not a title', []),
        Prismic::Fragments::StructuredText::Block::Heading.new('This is a title, but not the highest', [], 3),
        Prismic::Fragments::StructuredText::Block::Heading.new('This is the highest title of the document', [], 1),
        Prismic::Fragments::StructuredText::Block::Text.new('This is not a title', [])
      ])
      @document.fragments['field5'] = Prismic::Fragments::StructuredText.new([
        Prismic::Fragments::StructuredText::Block::Text.new('This is not a title', []),
        Prismic::Fragments::StructuredText::Block::Heading.new('This is a title, but not the highest', [], 3),
        Prismic::Fragments::StructuredText::Block::Heading.new('This is the highest title of the fragment, but not the document', [], 2),
        Prismic::Fragments::StructuredText::Block::Text.new('This is not a title', [])
      ])
      expect(@document.first_title).to eq('This is the highest title of the document')
    end

    it 'returns false if no title' do
      expect(@document.first_title).to be(false)
    end
  end

  describe 'slug' do
    it 'returns the first slug if found' do
      expect(@document.slug).to eq('my-slug')
    end

    it "returns '-' if no slug found" do
      @document.slugs = []
      expect(@document.slug).to eq('-')
    end
  end

  describe 'as_html' do
    it 'returns a <section> HTML element' do
      expect(Nokogiri::XML(@document.as_html(@link_resolver)).child.name).to eq('section')
    end

    it "returns a HTML element with a 'data-field' attribute" do
      expect(Nokogiri::XML(@document.as_html(@link_resolver)).child.has_attribute?('data-field')).to be(true)
    end

    it "returns a HTML element with a 'data-field' attribute containing the name of the field" do
      expect(Nokogiri::XML(@document.as_html(@link_resolver)).child.attribute('data-field').value).to eq('field1')
    end
  end
end

describe 'SearchForm' do
  before do
    @field = Prismic::Field.new('String', 'foo', true)
    @api = nil
  end

  def create_form(fields)
    form = Prismic::Form.new(nil, 'form1', fields, nil, nil, nil, nil)
    form.create_search_form
  end

  describe 'fields methods' do

    it 'should be created for each valid field names' do
      @form = create_form('a_param' => @field)
      expect(@form).to respond_to(:a_param)
    end

    it 'should be created for each valid field names with number' do
      @form = create_form('a_param2' => @field)
      expect(@form).to respond_to(:a_param2)
    end

    it 'should be created for each camelCase field names' do
      @form = create_form('anExampleParam0A0B' => @field)
      expect(@form).to respond_to(:an_example_param0_a0_b)
    end

    it 'should not be created for field names begining with a number' do
      @form = create_form('2param' => @field)
      expect(@form).not_to respond_to(:'2param')
    end

    it 'should not be created for field names begining with an underscore' do
      @form = create_form('_param' => @field)
      expect(@form).not_to respond_to(:'_param')
    end

    it 'should not be created for field names containing invalid characters' do
      @form = create_form('a-param' => @field)
      expect(@form).not_to respond_to(:'a-param')
    end

    it 'should not be created if a method with same name already exists' do
      Prismic::SearchForm.module_exec { def param_example_for_tests()
        'ok'
      end }
      @form = create_form('param_example_for_tests' => @field)
      expect(@form.param_example_for_tests).to eq('ok')
    end

  end

  describe 'set() for queries' do

    it 'append value for repeatable fields' do
      @field = Prismic::Field.new('String', 'foo', true)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      expect(@form.data).to eq({ 'q' => ['foo', 'bar'] })  # test the 1st call
      @form.set('q', 'baz')
      expect(@form.data).to eq({ 'q' => ['foo', 'bar', 'baz'] })  # test an other
    end

    it 'replace value for non repeatable fields' do
      @field = Prismic::Field.new('String', 'foo', false)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      expect(@form.data).to eq({ 'q' => 'bar' })  # test the 1st call
      @form.set('q', 'baz')
      expect(@form.data).to eq({ 'q' => 'baz' })  # test an other
    end

    it 'replace empty string value with nil' do
      @field = Prismic::Field.new('String', nil, true)
      @form = create_form('q' => @field)
      @form.set('q', '')
      expect(@form.data).to eq({ 'q' => nil })
    end

    it 'create value array for repeatable fields without value' do
      @field = Prismic::Field.new('String', nil, true)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      expect(@form.data).to eq({ 'q' => ['bar'] })
    end

    it 'create value for non repeatable fields without value' do
      @field = Prismic::Field.new('String', nil, false)
      @form = create_form('q' => @field)
      @form.set('q', 'bar')
      expect(@form.data).to eq({ 'q' => 'bar' })
    end

    it 'returns the form itself' do
      @form = create_form('q' => @field)
      expect(@form.query('foo')).to eq(@form)
    end

    it 'merge user defined params into default ones' do
      field = ->(value){ Prismic::Field.new('String', value) }
      default_params = {'param1' => field.('a'), 'param2' => field.('b')}
      @form = create_form(default_params)
      @form.set('param1', 'a2')
      expect(@form.data).to eq({'param1' => 'a2', 'param2' => 'b'})
    end
  end

  describe 'submit' do
    it 'raises an exception if no ref is set' do
      @form = create_form('q' => @field)
      expect { @form.submit }.to raise_error Prismic::SearchForm::NoRefSetException
    end
  end

end
