# encoding: utf-8
require 'spec_helper'

describe Prismic::API do
  before do
    @api = Prismic.api('https://micro.prismic.io/api', nil)
  end

  describe '#query' do
    it 'returns the documents filter by the query' do
      docs = @api.query(Prismic::Predicates::at('document.id', 'UrDejAEAAFwMyrW9'))
      expect(docs.size).to eq(1)
      expect(docs[0].id).to eq('UrDejAEAAFwMyrW9')
    end

    it 'handles multiple predicates' do
      docs = @api.query([
        Prismic::Predicates::at('document.type', 'all'),
        Prismic::Predicates::at('my.all.uid', 'all')
      ])
      expect(docs.size).to eq(1)
      expect(docs[0].id).to eq('WHx-gSYAAMkyXYX_')
    end
  end

  describe '#all' do
    it 'returns all documents' do
      docs = @api.all()
      expect(docs.size).to be >= 20
    end
  end

  describe '#get_by_id' do
    it 'returns the right document' do
      doc = @api.get_by_id('UrDejAEAAFwMyrW9')
      expect(doc.id).to eq('UrDejAEAAFwMyrW9')
    end
  end

  describe '#get_by_uid' do
    it 'returns the right document' do
      doc = @api.get_by_uid('with-uid', 'demo')
      expect(doc.id).to eq('V_OoLCYAAFv84agw')
    end
  end

  describe '#get_by_ids' do
    it 'returns the right documents' do
      docs = @api.get_by_ids(['UrDejAEAAFwMyrW9', 'V2OokCUAAHSZcOUP'])
      expect(docs.size).to eq(2)
      expect(docs[0].id).to eq('UrDejAEAAFwMyrW9')
      expect(docs[1].id).to eq('V2OokCUAAHSZcOUP')
    end
  end

  describe '#get_single' do
    it 'returns the singleton document of a type' do
      # 'single' is the type name
      doc = @api.get_single('single')
      expect(doc.id).to eq('V_OplCUAACQAE0lA')
    end
  end

end
