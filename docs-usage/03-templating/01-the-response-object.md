# The response object

After you set up your Custom Types and have queried your content from the API, it's time to integrate that content into your templates.

First we'll go over the response object returned from the API, then we'll discuss how to access the results of the query.

## The Response Object

Let’s start by taking a look at the Response Object returned when querying the API. Here is a simple example of response object with one document that contains a couple of fields.

```
--- !ruby/object:Prismic::Response
page: 1
results_per_page: 20
results_size: 1
total_results_size: 1
total_pages: 1
next_page: nil
prev_page: nil
results:
- !ruby/object:Prismic::Document
  id: WKxlPCUAAIZ10EHU
  uid: example-page
  type: page
  href: https://your-repo-name.prismic.io/api/documents/search?ref=WKxlPyUEEAdz...,
  tags: []
  slugs:
  - example-page
  first_publication_date: 2017-01-13 11:45:21.000000000 +00:00
  last_publication_date: 2017-02-21 16:05:19.000000000 +00:00
  lang: en-us
  alternate_languages:
    fr-fr: !ruby/object:Prismic::AlternateLanguage
      id: WZcAEyoAACcA0LHi
      uid: example-page-french
      type: page
      lang: fr-fr
  fragments:
    title: !ruby/object:Prismic::Fragments::StructuredText
      blocks:
      - !ruby/object:Prismic::Fragments::StructuredText::Block::Heading
        text: Example Page
        spans: []
        label:
        level: 1
    date: !ruby/object:Prismic::Fragments::Date
      value: 2017-01-13 00:00:00.000000000 +01:00
```

At the topmost level of the response object, you mostly have information about the number of results returned from the query and the pagination of the results.

| Property                                 | Description                                                                           |
| ---------------------------------------- | ------------------------------------------------------------------------------------- |
| <strong>page</strong><br/>               | <p>The current page of the pagination of the results</p>                              |
| <strong>results_per_page</strong><br/>   | <p>The number of documents per page of the pagination</p>                             |
| <strong>results_size</strong><br/>       | <p>The number of documents on this page of the pagination results</p>                 |
| <strong>total_results_size</strong><br/> | <p>The total number of documents returned from the query</p>                          |
| <strong>total_pages</strong><br/>        | <p>The total number of pages in the pagination of the results</p>                     |
| <strong>next_page</strong><br/>          | <p>The next page number in the pagination</p>                                         |
| <strong>prev_page</strong><br/>          | <p>The previous page number in the pagination</p>                                     |
| <strong>results</strong><br/>            | <p>The documents and their content for this page of the pagination of the results</p> |

> Note that when using certain helper functions such as getSingle(), getByUID(), or getByID(), the results will automatically be returned.

## The Query Results

The actual content of the returned documents can be found under "results". This will always be an array of the documents, even if there is only one document returned.

Let’s say that you saved your response object in a variable named "response". This would mean that your documents could be accessed with the following:

```ruby
response.results
```

And if you only returned one document, it would be accessed with the following:

```ruby
response.results[0]
```

Each document will contain information such as its document ID, UID, type, tags, slugs, first publication date, & last publication date.

The content for each document will be found inside "fragments". In the example above you have `title` and `date`.

## Content Field Helper Functions

The Ruby development kit provided by prismic.io comes with helper functions that make it easy to retrieve the content for each content field type.

These will all look something like the following.

```ruby
document["page.illustration"].url
```

In the case above, "page" is the API-ID of the Custom Type and "illustration" is the API ID of the Image field.

The helper functions available for each content field are shown on their individual templating pages.
