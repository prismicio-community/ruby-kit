# Query a Single type document

Here we discuss how to retrieve the content for a Single type document.

## getSingle helper function

In this example we are querying for the single instance of the custom type "navigation". We will do so by using the `getSingle` query helper function available in the Ruby development kit.

```ruby
document = api.getSingle("navigation")
# document contains the document content
```

## Without the helper

You can perform the same query without using the helper function. Here we again query the single document of the type "navigation".

```ruby
response = api.query(Prismic::Predicates.at("document.type", "navigation"))
# response.results[0] contains the document content
```

> **Querying by language**
>
> Note that if you are trying to query a document that isn't in the master language of your repository this way, you will need to specify the language code or wildcard language value. You can read how to do this on the [Query by Language page](../02-query-the-api/17-query-by-language.md).
>
> If you are using the query helper function above, you do not need to do this.
