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

  describe 'fulltext predicate' do
    it 'with helper serializes well' do
      form = @api.form('everything').query(Predicates.fulltext('document.type', ['article', 'blog-post']))
      form.data['q'].should == ['[[:d = fulltext(document.type, ["article", "blog-post"])]]']
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

  describe 'has predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['has', 'my.blog-post.author'])
      form.data['q'].should == ['[[:d = has(my.blog-post.author)]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(Predicates.has('my.blog-post.author'))
      form.data['q'].should == ['[[:d = has(my.blog-post.author)]]']
    end
  end

  describe 'missing predicate' do
    it 'as an array serializes well' do
      form = @api.form('everything').query(['missing', 'my.blog-post.author'])
      form.data['q'].should == ['[[:d = missing(my.blog-post.author)]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(Predicates.missing('my.blog-post.author'))
      form.data['q'].should == ['[[:d = missing(my.blog-post.author)]]']
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

  describe 'number GT' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.gt('my.blog-post.publication-date', 4)
      )
      form.data['q'].should == ['[[:d = number.gt(my.blog-post.publication-date, 4)]]']
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

  describe 'date is before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.date_before('my.blog-post.publication-date', Date.parse('2016-03-02') )
      )
      form.data['q'].should == ['[[:d = date.before(my.blog-post.publication-date, 1456898400000)]]']
    end
  end

  describe 'date is after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.date_after('my.blog-post.publication-date', Date.parse('2016-03-02') )
      )
      form.data['q'].should == ['[[:d = date.after(my.blog-post.publication-date, 1456898400000)]]']
    end
  end

  describe 'date is between' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.date_between('my.blog-post.publication-date', Date.parse('2016-03-02'), Date.parse('2016-03-04') )
      )
      form.data['q'].should == ['[[:d = date.between(my.blog-post.publication-date, 1456898400000, 1457071200000)]]']
    end
  end

  describe 'day of month' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_month('my.blog-post.publication-date', 10)
      )
      form.data['q'].should == ['[[:d = date.day-of-month(my.blog-post.publication-date, 10)]]']
    end
  end

  describe 'day of month after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_month_after('my.blog-post.publication-date', 10)
      )
      form.data['q'].should == ['[[:d = date.day-of-month-after(my.blog-post.publication-date, 10)]]']
    end
  end

  describe 'day of month before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_month_before('my.blog-post.publication-date', 10)
      )
      form.data['q'].should == ['[[:d = date.day-of-month-before(my.blog-post.publication-date, 10)]]']
    end
  end

  describe 'day of week' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_week('my.blog-post.publication-date', 7)
      )
      form.data['q'].should == ['[[:d = date.day-of-week(my.blog-post.publication-date, 7)]]']
    end
  end

  describe 'day of week after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_week_after('my.blog-post.publication-date', 7)
      )
      form.data['q'].should == ['[[:d = date.day-of-week-after(my.blog-post.publication-date, 7)]]']
    end
  end

  describe 'day of week before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.day_of_week_before('my.blog-post.publication-date', 7)
      )
      form.data['q'].should == ['[[:d = date.day-of-week-before(my.blog-post.publication-date, 7)]]']
    end
  end

  describe 'month' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month('my.blog-post.publication-date', 5)
      )
      form.data['q'].should == ['[[:d = date.month(my.blog-post.publication-date, 5)]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month('my.blog-post.publication-date', 'May')
      )
      form.data['q'].should == ['[[:d = date.month(my.blog-post.publication-date, "May")]]']
    end
  end

  describe 'month after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_after('my.blog-post.publication-date', 4)
      )
      form.data['q'].should == ['[[:d = date.month-after(my.blog-post.publication-date, 4)]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_after('my.blog-post.publication-date', 'April')
      )
      form.data['q'].should == ['[[:d = date.month-after(my.blog-post.publication-date, "April")]]']
    end
  end

  describe 'month before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_before('my.blog-post.publication-date', 12)
      )
      form.data['q'].should == ['[[:d = date.month-before(my.blog-post.publication-date, 12)]]']
    end
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.month_before('my.blog-post.publication-date', 'December')
      )
      form.data['q'].should == ['[[:d = date.month-before(my.blog-post.publication-date, "December")]]']
    end
  end

  describe 'year' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.year('my.blog-post.publication-date', 2013)
      )
      form.data['q'].should == ['[[:d = date.year(my.blog-post.publication-date, 2013)]]']
    end
  end

  describe 'year before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.year_before('my.blog-post.publication-date', 2013)
      )
      form.data['q'].should == ['[[:d = date.year-before(my.blog-post.publication-date, 2013)]]']
    end
  end

  describe 'year after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.year_after('my.blog-post.publication-date', 2011)
      )
      form.data['q'].should == ['[[:d = date.year-after(my.blog-post.publication-date, 2011)]]']
    end
  end

  describe 'hour' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.hour('my.blog-post.publication-date', 2)
      )
      form.data['q'].should == ['[[:d = date.hour(my.blog-post.publication-date, 2)]]']
    end
  end

  describe 'hour before' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.hour_before('my.blog-post.publication-date', 12)
      )
      form.data['q'].should == ['[[:d = date.hour-before(my.blog-post.publication-date, 12)]]']
    end
  end

  describe 'hour after' do
    it 'with helpers serializes well' do
      form = @api.form('everything').query(
          Predicates.hour_after('my.blog-post.publication-date', 17)
      )
      form.data['q'].should == ['[[:d = date.hour-after(my.blog-post.publication-date, 17)]]']
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
