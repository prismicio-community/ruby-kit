module Prismic
  module Predicates

    def self.at(fragment, value)
      ['at', fragment, value]
    end

    def self.not(fragment, value)
      ['not', fragment, value]
    end

    def self.in(fragment, value)
      ['in', fragment, value]
    end

    def self.any(fragment, values)
      ['any', fragment, values]
    end

    def self.fulltext(fragment, values)
      ['fulltext', fragment, values]
    end

    def self.similar(fragment, value)
      ['similar', fragment, value]
    end

    def self.has(fragment)
      ['has', fragment]
    end

    def self.missing(fragment)
      ['missing', fragment]
    end

    def self.gt(fragment, value)
      ['number.gt', fragment, value]
    end

    def self.lt(fragment, value)
      ['number.lt', fragment, value]
    end

    def self.in_range(fragment, before, after)
      ['number.inRange', fragment, before, after]
    end

    def self.date_before(fragment, before)
      ['date.before', fragment, as_timestamp(before)]
    end

    def self.date_after(fragment, after)
      ['date.after', fragment, as_timestamp(after)]
    end

    def self.date_between(fragment, before, after)
      ['date.between', fragment, as_timestamp(before), as_timestamp(after)]
    end

    def self.day_of_month(fragment, day)
      ['date.day-of-month', fragment, day]
    end

    def self.day_of_month_after(fragment, day)
      ['date.day-of-month-after', fragment, day]
    end

    def self.day_of_month_before(fragment, day)
      ['date.day-of-month-before', fragment, day]
    end

    def self.day_of_week(fragment, day)
      ['date.day-of-week', fragment, day]
    end

    def self.day_of_week_after(fragment, day)
      ['date.day-of-week-after', fragment, day]
    end

    def self.day_of_week_before(fragment, day)
      ['date.day-of-week-before', fragment, day]
    end

    def self.month(fragment, month)
      ['date.month', fragment, month]
    end

    def self.month_before(fragment, month)
      ['date.month-before', fragment, month]
    end

    def self.month_after(fragment, month)
      ['date.month-after', fragment, month]
    end

    def self.year(fragment, year)
      ['date.year', fragment, year]
    end

    def self.year_before(fragment, year)
      ['date.year-before', fragment, year]
    end

    def self.year_after(fragment, year)
      ['date.year-after', fragment, year]
    end

    def self.hour(fragment, hour)
      ['date.hour', fragment, hour]
    end

    def self.hour_before(fragment, hour)
      ['date.hour-before', fragment, hour]
    end

    def self.hour_after(fragment, hour)
      ['date.hour-after', fragment, hour]
    end

    def self.near(fragment, latitude, longitude, radius)
      ['geopoint.near', fragment, latitude, longitude, radius]
    end

    def self.as_timestamp(date)
      if date.is_a? Date or date.is_a? DateTime
        date.to_time.to_i * 1000
      elsif date.is_a? Time
        date.to_i * 1000
      else
        date
      end
    end

    private_class_method :as_timestamp

  end
end
