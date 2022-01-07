# Fetch Linked Document Fields

You can use the fetchLinks option to add additional fields from a linked document to the query results.

## The fetchLinks option

The `fetchLinks` option allows you to retrieve a specific content field from a linked document and add it to the document response object.

Note that this will only retrieve content of the following field types:

- Color
- Content Relationship
- Date
- Image
- Key Text
- Number
- Select
- Timestamp

It is **not** possible to retrieve the following content field types:

- Embed
- GeoPoint
- Link
- Link to Media
- Rich Text
- Title
- Any field in a Group or Slice

The value you enter for the fetchLinks option needs to take the following format:

```ruby
{ "fetchLinks" => "{custom-type}.{field}" }
```

| Property                            | Description                                                                  |
| ----------------------------------- | ---------------------------------------------------------------------------- |
| <strong>{custom-type}</strong><br/> | <p>The custom type API-ID of the linked document</p>                         |
| <strong>{field}</strong><br/>       | <p>The API-ID of the field you wish to retrieve from the linked document</p> |

## A simple example

Here is a sample query that uses the fetchLinks option.

This example will query for the recipe with the uid "chocolate-chip-cookies". If the custom type "recipe" has a link to another custom type "author", then you can pull in certain fields from that linked document, in this case the "name" field.

```ruby
document = api.query(
    Prismic::Predicates.at("my.recipe.uid", "chocolate-chip-cookies"),
    { "fetchLinks" => "author.name" }
).results[0]

author = document["recipe.author-link"]
# author now works like a top-level document

author_name = author["author.name"].value
# author_name contains the text from the field "name"
```

## Fetch multiple fields

In order to fetch more than one field from the linked document, you just need to comma separate the desired fields. Here is an example that fetches the fields `name` and `picture` from the `author`\*\* \*\*custom type.

```ruby
{ "fetchLinks" => "author.name, author.picture" }
```
