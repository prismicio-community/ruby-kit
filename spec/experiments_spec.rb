# encoding: utf-8
require 'spec_helper'

describe "Experiments'" do

    before do
      @raw_json_experiments = File.read("#{File.dirname(__FILE__)}/responses_mocks/experiments.json")
      @json_experiments = JSON.load(@raw_json_experiments)
      @experiments = Prismic::Experiments.parse(@json_experiments)
    end

    it 'response is properly parsed' do
      first = @experiments.running[0]
      first.id.should == 'VDUBBawGAKoGelsX'
      first.google_id.should == '_UQtin7EQAOH5M34RQq6Dg'
      first.name.should == 'Exp 1'

      base = first.variations[0]
      base.id.should == 'VDUBBawGAKoGelsZ'
      base.label.should == 'Base'
      base.ref.should == 'VDUBBawGALAGelsa'
    end

    describe 'cookies' do
      it 'is empty' do
        @experiments.ref_from_cookie('').should be_nil
      end

      it 'invalid content' do
        @experiments.ref_from_cookie('Ponyes are awesome').should be_nil
      end

      it 'actual running variation index' do
        @experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%200').should == 'VDUBBawGALAGelsa'
        @experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%201').should == 'VDUUmHIKAZQKk9uq'
      end

      it 'index overflow' do
        @experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%209').should be_nil
        @experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%20-1').should be_nil
      end

      it 'unknown Google ID' do
        @experiments.ref_from_cookie('NotAGoodLookingId%200').should be_nil
        @experiments.ref_from_cookie('NotAGoodLookingId%201').should be_nil
      end

    end

end


