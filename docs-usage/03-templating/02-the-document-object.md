# The Document object

Here we will discuss the document object for Prismic when using the Ruby development kit.

> **Before Reading**
>
> This article assumes that you have queried your API and saved the document object in a variable named `document`.

## An example response

Let's start by taking a look at the Document Object returned when querying the API. Here is a simple example of a document that contains a couple of fields.

```ruby
--- !ruby/object:Prismic::Document
id: WKxlPCUAAIZ10EHU
uid: example-page
type: page
href: https://your-repo-name.prismic.io/api/documents/search?ref=WKxlPyUEEAdz...,
tags:
  - Tag 1
  - Tag 2
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

## Accessing Document Fields

Here is how to access each document field.

### ID

```javascript
document.id;
```

### UID

```javascript
document.uid;
```

### Type

```javascript
document.type;
```

### API Url

```javascript
document.href;
```

### Tags

```javascript
document.tags;
// returns an array
```

### First Publication Date

```javascript
document.first_publication_date;
```

### Last Publication Date

```javascript
document.last_publication_date;
```

### Language

```javascript
document.lang;
```

### Alternate Language Versions

```javascript
document.alternate_languages;
// returns an array
```

You can read more about this in the [Multi-language Templating](../03-templating/12-multi-language-info.md) page.

## Document Content

To retrieve the content fields from the document you must specify the API ID of the field. Here is an example that retrieves a Date field's content from the document. Here the Date field has the API ID of `date`.

```javascript
// Assuming the document is of the type 'page'
document["page.date"].value;
```

Refer to the specific templating documentation for each field to learn how to add content fields to your pages.
