# Use multiple Predicates

You can combine multiple predicates in a single query, for example querying for a certain custom type with a given tag.

You simply need to put all the predicates into a comma-separated array.

## Example 1

Here is an example that queries all of the documents of the custom type "blog-post" that have the tag "featured".

```ruby
response = api.query([
    Prismic::Predicates.at("document.type", "blog-post"),
    Prismic::Predicates.at("document.tags", ["featured"])]
)
# response contains the response object, response.results holds the documents
```

## Example 2

Here is an example that queries all of the documents of the custom type "employee" excluding those with the tag "manager".

```ruby
response = api.query([
    Prismic::Predicates.at("document.type", "employee"),
    Prismic::Predicates.not("document.tags", ["manager"])]
)
# response contains the response object, response.results holds the documents
```
