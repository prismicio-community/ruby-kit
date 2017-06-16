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
      expect(form.data['q']).to eq(['[[:d = at(document.id, "UrjI1gEAALOCeO5i")]]'])
    end
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.at('document.id', 'UrjI1gEAALOCeO5i'))
      expect(form.data['q']).to eq(['[[:d = at(document.id, "UrjI1gEAALOCeO5i")]]'])
    end
  end

  describe 'not predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['not', 'document.id', 'UrjI1gEAALOCeO5i'])
      expect(form.data['q']).to eq(['[[:d = not(document.id, "UrjI1gEAALOCeO5i")]]'])
    end
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.not('document.id', 'UrjI1gEAALOCeO5i'))
      expect(form.data['q']).to eq(['[[:d = not(document.id, "UrjI1gEAALOCeO5i")]]'])
    end
  end

  describe 'any predicate' do
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.any('document.type', ['article', 'blog-post']))
      expect(form.data['q']).to eq(['[[:d = any(document.type, ["article", "blog-post"])]]'])
    end
  end

  describe 'fulltext predicate' do
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.fulltext('document.type', ['article', 'blog-post']))
      expect(form.data['q']).to eq(['[[:d = fulltext(document.type, ["article", "blog-post"])]]'])
    end
  end

  describe 'similar predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['similar', 'idOfSomeDocument', 10])
      expect(form.data['q']).to eq(['[[:d = similar("idOfSomeDocument", 10)]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(Predicates.similar('idOfSomeDocument', 10))
      expect(form.data['q']).to eq(['[[:d = similar("idOfSomeDocument", 10)]]'])
    end
  end

  describe 'has predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['has', 'my.blog-post.author'])
      expect(form.data['q']).to eq(['[[:d = has(my.blog-post.author)]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(Predicates.has('my.blog-post.author'))
      expect(form.data['q']).to eq(['[[:d = has(my.blog-post.author)]]'])
    end
  end

  describe 'missing predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['missing', 'my.blog-post.author'])
      expect(form.data['q']).to eq(['[[:d = missing(my.blog-post.author)]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(Predicates.missing('my.blog-post.author'))
      expect(form.data['q']).to eq(['[[:d = missing(my.blog-post.author)]]'])
    end
  end

  describe 'multiple predicates' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(
          ['date.month-after', 'my.blog-post.publication-date', 4],
          ['date.month-before', 'my.blog-post.publication-date', 'December']
      )
      expect(form.data['q']).to eq(['[[:d = date.month-after(my.blog-post.publication-date, 4)][:d = date.month-before(my.blog-post.publication-date, "December")]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_after('my.blog-post.publication-date', 4),
          Predicates.month_before('my.blog-post.publication-date', 'December')
      )
      expect(form.data['q']).to eq(['[[:d = date.month-after(my.blog-post.publication-date, 4)][:d = date.month-before(my.blog-post.publication-date, "December")]]'])
    end
  end

  describe 'number GT' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.gt('my.blog-post.publication-date', 4)
      )
      expect(form.data['q']).to eq(['[[:d = number.gt(my.blog-post.publication-date, 4)]]'])
    end
  end

  describe 'number LT' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.lt('my.blog-post.publication-date', 4)
      )
      expect(form.data['q']).to eq(['[[:d = number.lt(my.blog-post.publication-date, 4)]]'])
    end
  end

  describe 'number in range' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.in_range('my.product.price', 2, 4.5)
      )
      expect(form.data['q']).to eq(['[[:d = number.inRange(my.product.price, 2, 4.5)]]'])
    end
  end

  describe 'date is before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.date_before('my.blog-post.publication-date', Date.parse('2016-03-02') )
      )
      expect(form.data['q']).to eq(["[[:d = date.before(my.blog-post.publication-date, #{Date.parse('2016-03-02').to_time.to_i * 1000})]]"])
    end
  end

  describe 'date is after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.date_after('my.blog-post.publication-date', Date.parse('2016-03-02') )
      )
      expect(form.data['q']).to eq(["[[:d = date.after(my.blog-post.publication-date, #{Date.parse('2016-03-02').to_time.to_i * 1000})]]"])
    end
  end

  describe 'date is between' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.date_between('my.blog-post.publication-date', Date.parse('2016-03-02'), Date.parse('2016-03-04') )
      )
      expect(form.data['q']).to eq(["[[:d = date.between(my.blog-post.publication-date, #{Date.parse('2016-03-02').to_time.to_i * 1000}, #{Date.parse('2016-03-04').to_time.to_i * 1000})]]"])
    end
  end

  describe 'day of month' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_month('my.blog-post.publication-date', 10)
      )
      expect(form.data['q']).to eq(['[[:d = date.day-of-month(my.blog-post.publication-date, 10)]]'])
    end
  end

  describe 'day of month after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_month_after('my.blog-post.publication-date', 10)
      )
      expect(form.data['q']).to eq(['[[:d = date.day-of-month-after(my.blog-post.publication-date, 10)]]'])
    end
  end

  describe 'day of month before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_month_before('my.blog-post.publication-date', 10)
      )
      expect(form.data['q']).to eq(['[[:d = date.day-of-month-before(my.blog-post.publication-date, 10)]]'])
    end
  end

  describe 'day of week' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_week('my.blog-post.publication-date', 7)
      )
      expect(form.data['q']).to eq(['[[:d = date.day-of-week(my.blog-post.publication-date, 7)]]'])
    end
  end

  describe 'day of week after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_week_after('my.blog-post.publication-date', 7)
      )
      expect(form.data['q']).to eq(['[[:d = date.day-of-week-after(my.blog-post.publication-date, 7)]]'])
    end
  end

  describe 'day of week before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_week_before('my.blog-post.publication-date', 7)
      )
      expect(form.data['q']).to eq(['[[:d = date.day-of-week-before(my.blog-post.publication-date, 7)]]'])
    end
  end

  describe 'month' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month('my.blog-post.publication-date', 5)
      )
      expect(form.data['q']).to eq(['[[:d = date.month(my.blog-post.publication-date, 5)]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month('my.blog-post.publication-date', 'May')
      )
      expect(form.data['q']).to eq(['[[:d = date.month(my.blog-post.publication-date, "May")]]'])
    end
  end

  describe 'month after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_after('my.blog-post.publication-date', 4)
      )
      expect(form.data['q']).to eq(['[[:d = date.month-after(my.blog-post.publication-date, 4)]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_after('my.blog-post.publication-date', 'April')
      )
      expect(form.data['q']).to eq(['[[:d = date.month-after(my.blog-post.publication-date, "April")]]'])
    end
  end

  describe 'month before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_before('my.blog-post.publication-date', 12)
      )
      expect(form.data['q']).to eq(['[[:d = date.month-before(my.blog-post.publication-date, 12)]]'])
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_before('my.blog-post.publication-date', 'December')
      )
      expect(form.data['q']).to eq(['[[:d = date.month-before(my.blog-post.publication-date, "December")]]'])
    end
  end

  describe 'year' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.year('my.blog-post.publication-date', 2013)
      )
      expect(form.data['q']).to eq(['[[:d = date.year(my.blog-post.publication-date, 2013)]]'])
    end
  end

  describe 'year before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.year_before('my.blog-post.publication-date', 2013)
      )
      expect(form.data['q']).to eq(['[[:d = date.year-before(my.blog-post.publication-date, 2013)]]'])
    end
  end

  describe 'year after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.year_after('my.blog-post.publication-date', 2011)
      )
      expect(form.data['q']).to eq(['[[:d = date.year-after(my.blog-post.publication-date, 2011)]]'])
    end
  end

  describe 'hour' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.hour('my.blog-post.publication-date', 2)
      )
      expect(form.data['q']).to eq(['[[:d = date.hour(my.blog-post.publication-date, 2)]]'])
    end
  end

  describe 'hour before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.hour_before('my.blog-post.publication-date', 12)
      )
      expect(form.data['q']).to eq(['[[:d = date.hour-before(my.blog-post.publication-date, 12)]]'])
    end
  end

  describe 'hour after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.hour_after('my.blog-post.publication-date', 17)
      )
      expect(form.data['q']).to eq(['[[:d = date.hour-after(my.blog-post.publication-date, 17)]]'])
    end
  end

  describe 'geopoint near' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.near('my.store.coordinates', 40.689757, -74.0451453, 15)
      )
      expect(form.data['q']).to eq(['[[:d = geopoint.near(my.store.coordinates, 40.689757, -74.0451453, 15)]]'])
    end
  end

end
