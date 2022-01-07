# Templating Link & Content Relationship fields

The Link field is used for adding links to the web, to documents in your prismic.io repository, or to files in your prismic.io media library. The Content Relationship field is a Link field specifically used to link to a Document.

## Link to the Web

Her's how to retrieve the url for a Link to the Web which has the API ID of `external_link`.

```
<% web_link = @document["page.external_link"] %>
<% link_url = web_link.url(link_resolver) %>
<% if web_link.target %>
  <a href="<%= link_url %>" target="<%= web_link.target %>" rel="noopener">Click here</a>
<% else %>
  <a href="<%= link_url %>">Click here</a>
<% end %>
```

Note that the example above uses a Link Resolver. If your link field has been set up so that it can only take a Link to the Web, then this is not needed. You only need a Link Resolver if the Link field might contain a Link to a Document. Follow this link to read more about [Link Resolving](../04-beyond-the-api/01-link-resolving.md).

## Link to a Document / Content Relationship

### Retrieve the url for the Document

When integrating a Link to a Document in your repository, a Link Resolver is necessary as shown below.

```
<% doc_link = @document["page.document-link"].url(link_resolver) %>
<a href="<%= doc_link %>">Go to page</a>
```

Note that the example above uses a Link Resolver. A Link Resolver is required when retrieving the url for a Link to a Document.

### Retrieve other information about the Document

You are also able to retrieve other information about the linked Document. Here are some examples.

```
doc_id = @document["page.document-link"].id
doc_uid = @document["page.document-link"].uid
doc_type = @document["page.document-link"].type
doc_tags = @document["page.document-link"].tags
doc_lang = @document["page.document-link"].lang
```

## Link to a Media Item

The following shows how to retrieve the url for a Link to a Media Item.

```
<% media_link = @document["page.media-link"].url(link_resolver) %>
<a href="<%= media_link %>">View Image</a>
```

> Note that the example above uses a [Link Resolver](../04-beyond-the-api/01-link-resolving.md). If your link field has been set up so that it can only link to a Media Item, then this is not needed. You only need a Link Resolver if the Link field might contain a Link to a Document.
