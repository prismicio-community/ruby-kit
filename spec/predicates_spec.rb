# encoding: utf-8
require 'spec_helper'

Predicates = Prismic::Predicates

describe 'predicates' do
  before do
    @api = Prismic.api('https://micro.prismic.io/api', nil)
    @master_ref = @api.master_ref
    @link_resolver = Prismic.link_resolver('master'){|doc_link| "http://localhost/#{doc_link.id}" }
  end

  describe 'at predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['at', 'document.id', 'UrjI1gEAALOCeO5i'])
      form.data['q'].should == ['[[:d = at(document.id, "UrjI1gEAALOCeO5i")]]']
    end
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.at('document.id', 'UrjI1gEAALOCeO5i'))
      form.data['q'].should == ['[[:d = at(document.id, "UrjI1gEAALOCeO5i")]]']
    end
  end

  describe 'any predicate' do
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.any('document.type', ['article', 'blog-post']))
      form.data['q'].should == ['[[:d = any(document.type, ["article", "blog-post"])]]']
    end
  end

  describe 'similar predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['similar', 'idOfSomeDocument', 10])
      form.data['q'].should == ['[[:d = similar("idOfSomeDocument", 10)]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(Predicates.similar('idOfSomeDocument', 10))
      form.data['q'].should == ['[[:d = similar("idOfSomeDocument", 10)]]']
    end
  end

  describe 'multiple predicates' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(
          ['date.month-after', 'my.blog-post.publication-date', 4],
          ['date.month-before', 'my.blog-post.publication-date', 'December']
      )
      form.data['q'].should == ['[[:d = date.month-after(my.blog-post.publication-date, 4)][:d = date.month-before(my.blog-post.publication-date, "December")]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_after('my.blog-post.publication-date', 4),
          Predicates.month_before('my.blog-post.publication-date', 'December')
      )
      form.data['q'].should == ['[[:d = date.month-after(my.blog-post.publication-date, 4)][:d = date.month-before(my.blog-post.publication-date, "December")]]']
    end
  end

  describe 'number LT' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.lt('my.blog-post.publication-date', 4)
      )
      form.data['q'].should == ['[[:d = number.lt(my.blog-post.publication-date, 4)]]']
    end
  end

  describe 'number in range' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.in_range('my.product.price', 2, 4.5)
      )
      form.data['q'].should == ['[[:d = number.inRange(my.product.price, 2, 4.5)]]']
    end
  end

  describe 'geopoint near' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.near('my.store.coordinates', 40.689757, -74.0451453, 15)
      )
      form.data['q'].should == ['[[:d = geopoint.near(my.store.coordinates, 40.689757, -74.0451453, 15)]]']
    end
  end

end
