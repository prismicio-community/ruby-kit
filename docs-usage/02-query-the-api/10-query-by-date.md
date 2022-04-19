# Query by Date

This page shows multiple ways to query documents based on a date field.

Here we use a few predicates that can query based on Date or Timestamp fields. Feel free to explore the[ Date & Time based Predicate Reference](../02-query-the-api/02-date-and-time-based-predicate-reference.md) page to learn more about this.

## Query by an exact date

The following is an example that shows how to query for all the documents of the type "article" with the release-date field ("date") equal to October 22, 2020.

> Note that this type of query will only work for the Date Field, not the Time Stamp field.

```ruby
date = Date.new(2017, 1, 22)
response = api.query(
    Prismic::Predicates.at("my.article.release-date", date.strftime())
)
# response is the response object, response.results holds the documents
```

## Query by month and year

Here is an example of a query for all documents of the type "blog-post" whose release-date is in the month of May in the year 2019. This might be useful for a blog archive.

```ruby
response = api.query([
    Prismic::Predicates.month("my.blog-post.release-date", "May"),
    Prismic::Predicates.year("my.blog-post.release-date", 2019)
])
# response is the response object, response.results holds the documents
```

## Query by publication date

You can also query documents by their first or last publication dates.

Here is an example of a query for all documents of the type "blog-post" whose original publication date is in the month of January in the year 2019.

```ruby
response = api.query([
   Prismic::Predicates.at("document.type", "blog-post"),
   Prismic::Predicates.month("document.first_publication_date", "january"),
   Prismic::Predicates.year("document.first_publication_date", 2017)
])
# response is the response object, response.results holds the documents
```
