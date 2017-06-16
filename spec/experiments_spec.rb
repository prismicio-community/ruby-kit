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
      expect(first.id).to eq('VDUBBawGAKoGelsX')
      expect(first.google_id).to eq('_UQtin7EQAOH5M34RQq6Dg')
      expect(first.name).to eq('Exp 1')

      base = first.variations[0]
      expect(base.id).to eq('VDUBBawGAKoGelsZ')
      expect(base.label).to eq('Base')
      expect(base.ref).to eq('VDUBBawGALAGelsa')
    end

    describe 'cookies' do
      it 'is empty' do
        expect(@experiments.ref_from_cookie('')).to be(nil)
      end

      it 'invalid content' do
        expect(@experiments.ref_from_cookie('Ponyes are awesome')).to be(nil)
      end

      it 'actual running variation index' do
        expect(@experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%200')).to eq('VDUBBawGALAGelsa')
        expect(@experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%201')).to eq('VDUUmHIKAZQKk9uq')
      end

      it 'index overflow' do
        expect(@experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%209')).to be(nil)
        expect(@experiments.ref_from_cookie('_UQtin7EQAOH5M34RQq6Dg%20-1')).to be(nil)
      end

      it 'unknown Google ID' do
        expect(@experiments.ref_from_cookie('NotAGoodLookingId%200')).to be(nil)
        expect(@experiments.ref_from_cookie('NotAGoodLookingId%201')).to be(nil)
      end

    end

end
