# Query all your documents

This page shows you how to query all the documents in your prismic.io content repository.

## Without query options

Here is an example that will query your repository for all documents using the `all` function.

By default, the API will paginate the results, with 20 documents per page.

```ruby
response = api.all()
# response is the response object, response.results holds the documents
```

## With query options

You can add options to this query. In the following example we allow 100 documents per page for the query response.

```ruby
options = { "pageSize" => 100 }
response = api.all(options)
# response is the response object, response.results holds the documents
```
