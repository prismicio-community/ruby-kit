# How to Query the API

In order to retrieve the content from your repository, you will need to query the repository API and specify exactly what it is you are looking for. You could query the repository for all the documents of certain type or retrieve one specific document.

Let’s take a look at how to put together queries for whatever case you need.

## The Basics

When retrieving content from your Prismic repository, here's what a typical query looks like:

```ruby
response = api.query(
   Prismic::Predicates.at("document.type", "blog-post"),
   { "orderings" => "[my.blog-post.date desc]" }
)
# response is the response object, response.results holds the documents
```

This is the basic format of a query. In the query you have two parts, the Predicate and the options.

### Predicates

In the above example we had the following predicate:

```ruby
Prismic::Predicates.at("document.type", "blog-post")
```

The predicate(s) will define which documents are retrieved from the content repository. This particular example will retrieve all of the documents of the type "blog-post".

The first part, "document.type" is the **path**, or what the query will be looking for. The second part of the predicate in the above example is "blog-post" this is the value that the query is looking for.

You can combine more than one predicate together to refine your query. You just need to put all your predicates into a comma-separated array like the following example:

```ruby
[ Prismic::Predicates.at("document.type", "blog-post"),
  Prismic::Predicates.at("document.tags", ["featured"]) ]
```

This particular query will retrieve all the documents of the "blog-post" type that also have the tag "featured".

### Options

In the second part of the query, you can include the options needed for that query. In the above example we had the following options

```ruby
{ "orderings" => "[my.blog-post.date desc]" }
```

This specifies how the returned list of documents will be ordered. You can include more than one option, by comma separating them as shown below:

```ruby
{ "pageSize" => 10, "page" => 2 }
```

You will find a list and description of all the available options on the [Query Options Reference](../02-query-the-api/03-query-options-reference.md) page.

> **Pagination of API Results**
>
> When querying a Prismic repository, your results will be paginated. By default, there are 20 documents per page in the results. You can read more about how to manipulate the pagination in the [Pagination for Results](../02-query-the-api/16-pagination-for-results.md) page.

Here's another example of a more advanced query with multiple predicates and multiple options:

```ruby
response = api.query(
    [ Prismic::Predicates.at("document.type", "blog-post"),
      Prismic::Predicates.at("document.tags", ["featured"]) ],
    { "pageSize" => 10, "page" => 1, "orderings" => "[my.blog-post.date desc]" }
)
# response is the response object, response.results holds the documents
```

Whenever you query your content, you end up with the response object stored in the defined variable.
