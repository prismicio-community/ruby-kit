# Date & Time based Predicate Reference

This page describes and gives examples for all the date and time based predicates you can use when creating queries with the prismic.io Ruby development kit.

All of these predicates will work when used with either the Date or Timestamp fields, as well as the first and last publication dates.

Note that when using any of these predicates with either a Date or Timestamp field, you will limit the results of the query to the specified custom type.

## date_after

The `date_after` predicate checks that the value in the path is after the date value passed into the predicate.

This will not include anything with a date equal to the input value.

```css
Prismic::Predicates.date_after( path, date )
```

| Property                                                    | Description                                                                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>       | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>date</strong><br/><code>accepted date values</code> | <p>Date object: Date.new(YYYY, MM, DD)</p><p>String in the following format: &quot;YYYY-MM-DD&quot;</p>    |

Examples:

```ruby
Prismic::Predicates.date_after("document.first_publication_date", Date.new(2017, 5, 18))
Prismic::Predicates.date_after("document.last_publication_date", "2016-07-22")
Prismic::Predicates.date_after("my.article.release-date", "2017-01-23")
```

## date_before

The `date_before` predicate checks that the value in the path is before the date value passed into the predicate.

This will not include anything with a date equal to the input value.

```css
Prismic::Predicates.date_before( path, date )
```

| Property                                                    | Description                                                                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>       | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>date</strong><br/><code>accepted date values</code> | <p>Date object: Date.new(YYYY, MM, DD)</p><p>String in the following format: &quot;YYYY-MM-DD&quot;</p>    |

Examples:

```ruby
Prismic::Predicates.date_before("document.first_publication_date", "2016-09-19")
Prismic::Predicates.date_before("document.last_publication_date", Date.new(2016, 10, 15))
Prismic::Predicates.date_before("my.post.date", Date.new(2016, 08, 24))
```

## date_between

The `date_between` predicate checks that the value in the path is within the date values passed into the predicate.

```css
Prismic::Predicates.date_between( path, start_date, end_date )
```

| Property                                                          | Description                                                                                                |
| ----------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>             | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>start_date</strong><br/><code>accepted date values</code> | <p>Date object: Date.new(YYYY, MM, DD)</p><p>String in the following format: &quot;YYYY-MM-DD&quot;</p>    |
| <strong>end_date</strong><br/><code>accepted date values</code>   | <p>Date object: Date.new(YYYY, MM, DD)</p><p>String in the following format: &quot;YYYY-MM-DD&quot;</p>    |

Examples:

```ruby
Prismic::Predicates.date_between("document.first_publication_date", "2017-01-16", "2017-02-16")
Prismic::Predicates.date_between("document.last_publication_date", Date.new(2017, 01, 16), Date.new(2017, 02, 16))
Prismic::Predicates.date_between("my.blog-post.post-date", "2016-06-01", "2016-06-30")
```

## day_of_month

The `day_of_month` predicate checks that the value in the path is equal to the day of the month passed into the predicate.

```css
Prismic::Predicates.day_of_month( path, day )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>day</strong><br/><code>integer</code>         | <p>Day of the month</p>                                                                                    |

Examples:

```ruby
Prismic::Predicates.day_of_month("document.first_publication_date", 22)
Prismic::Predicates.day_of_month("document.last_publication_date", 30)
Prismic::Predicates.day_of_month("my.post.date", 14)
```

## day_of_month_after

The `day_of_month_after` predicate checks that the value in the path is after the day of the month passed into the predicate.

> Note that this will return only the days after the specified day of the month. It will not return any documents where the day is equal to the specified day.

```css
Prismic::Predicates.day_of_month_after( path, day )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>day</strong><br/><code>integer</code>         | <p>Day of the month</p>                                                                                    |

Examples:

```ruby
Prismic::Predicates.day_of_month_after("document.first_publication_date", 10)
Prismic::Predicates.day_of_month_after("document.last_publication_date", 15)
Prismic::Predicates.day_of_month_after("my.event.date-and-time", 21)
```

## day_of_month_before

The `day_of_month_before` predicate checks that the value in the path is before the day of the month passed into the predicate.

> Note that this will return only the days before the specified day of the month. It will not return any documents where the date is equal to the specified day.

```css
Prismic::Predicates.day_of_month_before( path, day )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>day</strong><br/><code>integer</code>         | <p>Day of the month</p>                                                                                    |

Examples:

```ruby
Prismic::Predicates.day_of_month_before("document.first_publication_date", 15)
Prismic::Predicates.day_of_month_before("document.last_publication_date", 10)
Prismic::Predicates.day_of_month_before("my.blog-post.release-date", 23)
```

## day_of_week

The `day_of_week` predicate checks that the value in the path is equal to the day of the week passed into the predicate.

```css
Prismic::Predicates.day_of_week( path, week_day )
```

| Property                                                       | Description                                                                                                |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>          | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>week_day</strong><br/><code>string\* or integer</code> | <pre>&quot;monday&quot;, &quot;mon&quot;, or 1                                                             |

&quot;tuesday&quot;, &quot;tue&quot;, or 2
&quot;wednesday&quot;, &quot;wed&quot;, or 3
&quot;thursday&quot;, &quot;thu&quot;, or 4
&quot;friday&quot;, &quot;fri&quot;, or 5
&quot;saturday&quot;, &quot;sat&quot;, or 6
&quot;sunday&quot;, &quot;sun&quot;, or 7</pre>|

For any of the string input values you can use either first letter capitalized, all lowercase, or all uppercase. For example, "Monday", "monday", and "MONDAY" are all accepted values.

Examples:

```ruby
Prismic::Predicates.day_of_week("document.first_publication_date", 1)
Prismic::Predicates.day_of_week("document.last_publication_date", "sunday")
Prismic::Predicates.day_of_week("my.concert.show-date", "Fri")
```

## day_of_week_after

The `day_of_week_after` predicate checks that the value in the path is after the day of the week passed into the predicate.

This predicate uses Monday as the beginning of the week:

1. Monday
1. Tuesday
1. Wednesday
1. Thursday
1. Friday
1. Saturday
1. Sunday

> Note that this will return only the days after the specified day of the week. It will not return any documents where the day is equal to the specified day.

```css
Prismic::Predicates.day_of_week_after( path, week_day )
```

| Property                                                       | Description                                                                                                |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>          | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>week_day</strong><br/><code>string\* or integer</code> | <pre>&quot;monday&quot;, &quot;mon&quot;, or 1                                                             |

&quot;tuesday&quot;, &quot;tue&quot;, or 2
&quot;wednesday&quot;, &quot;wed&quot;, or 3
&quot;thursday&quot;, &quot;thu&quot;, or 4
&quot;friday&quot;, &quot;fri&quot;, or 5
&quot;saturday&quot;, &quot;sat&quot;, or 6
&quot;sunday&quot;, &quot;sun&quot;, or 7</pre>|

For any of the string input values you can use either first letter capitalized, all lowercase, or all uppercase. For example, "Monday", "monday", and "MONDAY" are all accepted values.

Examples:

```ruby
Prismic::Predicates.day_of_week_after("document.first_publication_date", "friday")
Prismic::Predicates.day_of_week_after("document.last_publication_date", "THU")
Prismic::Predicates.day_of_week_after("my.blog-post.date", 2)
```

## day_of_week_before

The `day_of_week_before` predicate checks that the value in the path is before the day of the week passed into the predicate.

This predicate uses Monday as the beginning of the week:

1. Monday
1. Tuesday
1. Wednesday
1. Thursday
1. Friday
1. Saturday
1. Sunday

> Note that this will return only the days before the specified day of the week. It will not return any documents where the day is equal to the specified day.

```css
Prismic::Predicates.day_of_week_before( path, week_day )
```

| Property                                                       | Description                                                                                                |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>          | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>week_day</strong><br/><code>string\* or integer</code> | <pre>&quot;monday&quot;, &quot;mon&quot;, or 1                                                             |

&quot;tuesday&quot;, &quot;tue&quot;, or 2
&quot;wednesday&quot;, &quot;wed&quot;, or 3
&quot;thursday&quot;, &quot;thu&quot;, or 4
&quot;friday&quot;, &quot;fri&quot;, or 5
&quot;saturday&quot;, &quot;sat&quot;, or 6
&quot;sunday&quot;, &quot;sun&quot;, or 7</pre>|

For any of the string input values you can use either first letter capitalized, all lowercase, or all uppercase. For example, "Monday", "monday", and "MONDAY" are all accepted values.

Examples:

```ruby
Prismic::Predicates.day_of_week_before("document.first_publication_date", "Wed")
Prismic::Predicates.day_of_week_before("document.last_publication_date", 6)
Prismic::Predicates.day_of_week_before("my.page.release-date", "saturday")
```

## month

The `month` predicate checks that the value in the path occurs in the month value passed into the predicate.

```css
Prismic::Predicates.month( path, month )
```

| Property                                                    | Description                                                                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>       | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>month</strong><br/><code>string\* or integer</code> | <pre>&quot;january&quot;, &quot;jan&quot;, or 1                                                            |

&quot;february&quot;, &quot;feb&quot;, or 2
&quot;march&quot;, &quot;mar&quot;, or 3
&quot;april&quot;, &quot;apr&quot;, or 4
&quot;may&quot; or 5
&quot;june&quot;, &quot;jun&quot;, or 6
&quot;july&quot;, &quot;jul&quot;, or 7
&quot;august&quot;, &quot;aug&quot;, or 8
&quot;september&quot;, &quot;sep&quot;, or 9
&quot;october&quot;, &quot;oct&quot;, or 10
&quot;november&quot;, &quot;nov&quot;, or 11
&quot;december&quot;, &quot;dec&quot;, or 12</pre>|

For any of the string input values you can use either first letter capitalized, all lowercase, or all uppercase. For example, "January", "january", and "JANUARY" are all accepted values.

Examples:

```ruby
Prismic::Predicates.month("document.first_publication_date", "august")
Prismic::Predicates.month("document.last_publication_date", "Sep")
Prismic::Predicates.month("my.blog-post.date", 1)
```

## month_after

The `month_after` predicate checks that the value in the path occurs in any month after the value passed into the predicate.

> Note that this will only return documents where the date is after the specified month. It will not return any documents where the date is within the specified month.

```css
Prismic::Predicates.month_after( path, month )
```

| Property                                                    | Description                                                                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>       | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>month</strong><br/><code>string\* or integer</code> | <pre>&quot;january&quot;, &quot;jan&quot;, or 1                                                            |

&quot;february&quot;, &quot;feb&quot;, or 2
&quot;march&quot;, &quot;mar&quot;, or 3
&quot;april&quot;, &quot;apr&quot;, or 4
&quot;may&quot; or 5
&quot;june&quot;, &quot;jun&quot;, or 6
&quot;july&quot;, &quot;jul&quot;, or 7
&quot;august&quot;, &quot;aug&quot;, or 8
&quot;september&quot;, &quot;sep&quot;, or 9
&quot;october&quot;, &quot;oct&quot;, or 10
&quot;november&quot;, &quot;nov&quot;, or 11
&quot;december&quot;, &quot;dec&quot;, or 12</pre>|

For any of the string input values you can use either first letter capitalized, all lowercase, or all uppercase. For example, "January", "january", and "JANUARY" are all accepted values.

Examples:

```ruby
Prismic::Predicates.month_after("document.first_publication_date", "February")
Prismic::Predicates.month_after("document.last_publication_date", 6)
Prismic::Predicates.month_after("my.article.date", "oct")
```

## month_before

The `month_before` predicate checks that the value in the path occurs in any month before the value passed into the predicate.

> Note that this will only return documents where the date is before the specified month. It will not return any documents where the date is within the specified month.

```css
Prismic::Predicates.month_before( path, month )
```

| Property                                                    | Description                                                                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code>       | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>month</strong><br/><code>string\* or integer</code> | <pre>&quot;january&quot;, &quot;jan&quot;, or 1                                                            |

&quot;february&quot;, &quot;feb&quot;, or 2
&quot;march&quot;, &quot;mar&quot;, or 3
&quot;april&quot;, &quot;apr&quot;, or 4
&quot;may&quot; or 5
&quot;june&quot;, &quot;jun&quot;, or 6
&quot;july&quot;, &quot;jul&quot;, or 7
&quot;august&quot;, &quot;aug&quot;, or 8
&quot;september&quot;, &quot;sep&quot;, or 9
&quot;october&quot;, &quot;oct&quot;, or 10
&quot;november&quot;, &quot;nov&quot;, or 11
&quot;december&quot;, &quot;dec&quot;, or 12</pre>|

For any of the string input values you can use either first letter capitalized, all lowercase, or all uppercase. For example, "January", "january", and "JANUARY" are all accepted values.

Examples:

```ruby
Prismic::Predicates.month_before("document.first_publication_date", 8)
Prismic::Predicates.month_before("document.last_publication_date", "june")
Prismic::Predicates.month_before("my.blog-post.release-date", "Sep")
```

## year

The `year` predicate checks that the value in the path occurs in the year value passed into the predicate.

```css
Prismic::Predicates.year( path, year )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>year</strong><br/><code>integer</code>        | <p>Year</p>                                                                                                |

Examples:

```ruby
Prismic::Predicates.year("document.first_publication_date", 2016)
Prismic::Predicates.year("document.last_publication_date", 2017)
Prismic::Predicates.year("my.employee.birthday", 1986)
```

## hour

The `hour` predicate checks that the value in the path occurs within the hour value passed into the predicate.

This uses the 24 hour system, starting at 0 and going through 23.

> Note that this predicate will technically work for a Date field, but won’t be very useful. All date field values are automatically given an hour of 0.

```css
Prismic::Predicates.hour( path, hour )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>hour</strong><br/><code>integer</code>        | <p>Hour between 0 and 23</p>                                                                               |

Examples:

```ruby
Prismic::Predicates.hour("document.first_publication_date", 12)
Prismic::Predicates.hour("document.last_publication_date", 8)
Prismic::Predicates.hour("my.event.date-and-time", 19)
```

## hour_after

The `hour_after` predicate checks that the value in the path occurs after the hour value passed into the predicate.

This uses the 24 hour system, starting at 0 and going through 23.

> Note that this will only return documents where the timestamp is after the specified hour. It will not return any documents where the timestamp is within the specified hour.

> This predicate will technically work for a Date field, but won’t be very useful. All date field values are automatically given an hour of 0.

```css
Prismic::Predicates.hour_after( path, hour )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>hour</strong><br/><code>integer</code>        | <p>Hour between 0 and 23</p>                                                                               |

Examples:

```ruby
Prismic::Predicates.hour_after("document.first_publication_date", 21)
Prismic::Predicates.hour_after("document.last_publication_date", 8)
Prismic::Predicates.hour_after("my.blog-post.releaseDate", 16)
```

## hour_before

The `hour_before` predicate checks that the value in the path occurs before the hour value passed into the predicate.

This uses the 24 hour system, starting at 0 and going through 23.

> Note that this will only return documents where the timestamp is before the specified hour. It will not return any documents where the timestamp is within the specified hour.

> This predicate will technically work for a Date field, but won’t be very useful. All date field values are automatically given an hour of 0.

```css
Prismic::Predicates.hour_before( path, hour )
```

| Property                                              | Description                                                                                                |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <strong>path</strong><br/><code>accepted paths</code> | <p>document.first_publication_date</p><p>document.last_publication_date</p><p>my.{custom-type}.{field}</p> |
| <strong>hour</strong><br/><code>integer</code>        | <p>Hour between 0 and 23</p>                                                                               |

Examples:

```ruby
Prismic::Predicates.hour_before("document.first_publication_date", 10)
Prismic::Predicates.hour_before("document.last_publication_date", 14)
Prismic::Predicates.hour_before("my.event.dateAndTime", 12)
```
