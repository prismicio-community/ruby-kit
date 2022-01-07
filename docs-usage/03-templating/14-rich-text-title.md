# Templating the Rich Text & Title fields

The Rich Text field (formerly called Structured Text) is a configurable text field with formatting options. This field provides content writers with a WYSIWYG editor where they can define the text as a header or paragraph, make it bold, add links, etc. The Title field is a specific Rich Text field used for titles.

## Output as HTML

The basic usage of the Rich Text / Title field is to use the `as_html` method to transform the field into HTML code.

The following is an example that would display the title of a blog post.

```
<%= @document["blog-post.title"].as_html(link_resolver()).html_safe %>
```

In the previous example when calling the as_html  method, you need to pass in a Link Resolver function. This is needed if your content contains any links to documents in your repository. To read more about this, check out the [Link Resolving](../04-beyond-the-api/01-link-resolving.md) page.

### Example 2

The following example shows how to display the Rich Text body content of a blog post.

```
<%= @document["blog-post.body"].as_html(link_resolver()).html_safe %>
```

### Changing the HTML Output

You can customize the HTML output by passing an HTML serializer to the method as shown below.

To read more about this, check out the [HTML Serializer](../04-beyond-the-api/03-html-serializer.md) page.

The following example will edit how an image in a Rich Text field is displayed while leaving all the other elements in their default output.

```
@html_serializer = Prismic.html_serializer do |element, html|
  if element.is_a?(Prismic::Fragments::StructuredText::Block::Image)
    %(<img src="#{element.url}" alt="#{element.alt}" width="#{element.width}" height="#{element.height}" />)
  else
    nil
  end
end

# In the template
<%= @document['blog-post.body'].as_html(link_resolver(), @html_serializer).html_safe %>
```

## Output as plain text

The `as_text`  method will convert and output the text in the Rich Text / Title field as a string.

```
<h3 class="author">
  <%= @document["page.author"].as_text %>
</h3>
```

## Get the first heading

The `first_title`  method will find the highest and first heading block in the Rich Text field and return it as a string.

Here's an example of how to integrate this.

```
<h2><%= @document["page.body"].first_title %></h2>
```
