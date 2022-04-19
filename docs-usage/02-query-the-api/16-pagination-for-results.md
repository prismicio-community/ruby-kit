# Pagination for results

The results retrieved from the prismic.io repository will automatically be paginated. Here you will find an explanation for how to modify the pagination parameters.

## pageSize

The `pageSize` option defines the maximum number of documents that the API will return for your query.

If left unspecified, the pagination will default to 20. The maximum value allowed is 100.

Here is an example that shows how to query all of the documents of the custom type "recipe," allowing 100 documents per page.

```ruby
response = api.query(
   Prismic::Predicates.at("document.type", "recipe"),
   { "pageSize" => 100 }
)
# response contains the response object, response.results holds the documents
```

## page

The `page` option defines the pagination for the results of your query.

If left unspecified, it will default to 1, which corresponds to the first page.

Here is an example that show how to query all of the documents of the custom type "recipe". The options entered will limit the results to 50 recipes per page, and will display the third page of results.

```ruby
response = api.query(
    Prismic::Predicates.at("document.type", "recipe"),
    { "pageSize" => 50, "page" => 3 }
)
# response contains the response object, response.results holds the documents
```
