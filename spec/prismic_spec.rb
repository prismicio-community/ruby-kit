require 'spec_helper'

describe 'ApiData' do
  before do
    @data = {'refs' => [
      Ref.new('ref1', 'label1'),
      Ref.new('ref2', 'label2'),
      Ref.new('ref3', 'label3'),
      Ref.new('ref30', 'label3'),
      Ref.new('ref4', 'label4'),
    ]}
    @api_data = ApiData.new(@data)
  end

  describe 'refs' do
    it "returns a map with an element from each type" do
      @api_data.refs['label2'].ref.should == 'ref2'
    end

    it "returns a map with the correct number of elements" do
      @api_data.refs.size.should == 4
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
