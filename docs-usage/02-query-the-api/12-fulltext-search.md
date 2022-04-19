# Fulltext search

You can use the Fulltext predicate to search a document for a given term or terms.

The `Fulltext` predicate searches the term in any of the following fields:

- Rich Text
- Title
- Key Text
- UID
- Select

> Note that the fulltext search is not case sensitive.

## Example Query

This example shows how to query for all the documents of the custom type "blog-post" that contain the word "prismic".

```ruby
response = api.query([
    Prismic::Predicates.at("document.type", "blog-post"),
    Prismic::Predicates.fulltext("document", "prismic")]
)
# response contains the response object, response.results holds the documents
```
