require 'spec_helper'

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
