# Query by Tag

Here we show how to query all of the documents with a certain tag.

## Query a single tag

This example shows how to query all the documents with the tag "English".

```ruby
response = api.query(
    Prismic::Predicates.at("document.tags", ["English"])
)
# response is the response object, response.results holds the documents
```

## Query multiple tags

The following example shows how to query all of the documents with either the tag "Tag 1" or "Tag 2".

```ruby
response = api.query(
    Prismic::Predicates.any("document.tags", ["Tag 1", "Tag 2"])
)
# response is the response object, response.results holds the documents
```
