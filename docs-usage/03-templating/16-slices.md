# Templating Slices

The Slices field is used to define a dynamic zone for richer page layouts.

## Example 1

Here is a simple example that shows how to add slices to your templates. In this example, we have two slice options: a text slice and an image gallery slice.

### Text slice

The "text" slice is simple and only contains one field, which is non-repeatable.

| Property                             | Description                                                         |
| ------------------------------------ | ------------------------------------------------------------------- |
| <strong>non-repeatable</strong><br/> | <p>- A Rich Text field with the API ID of &quot;rich_text&quot;</p> |
| <strong>repeatable</strong><br/>     | <p>None</p>                                                         |

### Image gallery slice

The "image_gallery" slice contains both repeatable and non-repeatable fields.

| Property                             | Description                                                          |
| ------------------------------------ | -------------------------------------------------------------------- |
| <strong>non-repeatable</strong><br/> | <p>- A Title field with the API ID of &quot;gallery_title&quot;</p>  |
| <strong>repeatable</strong><br/>     | <p>- An Image field with the API ID of &quot;gallery_image&quot;</p> |

### Integration

Here is an example of how to integrate these slices into a blog post.

```
<div class="blog-content">
  <% @document["blog_post.body"].slices.each do |slice| %>
    <% case slice.slice_type
       when "text" %>
          <%= slice.non_repeat["rich_text"].as_html(link_resolver).html_safe %>
    <% when "image_gallery" %>
        <h2><%= slice.non_repeat["gallery_title"].as_text %></h2>
        <% slice.repeat.each do |image| %>
          <img src="<%= image["gallery_image"].url %>">
        <% end %>
    <% end %>
  <% end %>
</div>
```

## Example 2

The following is a more advanced example that shows how to use Slices for a landing page. In this example, the Slice choices are FAQ question/answers, featured items, and text sections.

### FAQ slice

The "faq" slice is takes advantage of both the repeatable and non-repeatable slice sections.

| Property                             | Description                                                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| <strong>non-repeatable</strong><br/> | <p>- A Title field with the API ID of &quot;faq_title&quot;</p>                                                                |
| <strong>repeatable</strong><br/>     | <p>- A Title field with the API ID of &quot;question&quot;</p><p>- A Rich Text field with the API ID of &quot;answer&quot;</p> |

### Featured Items slice

The "featured_items" slice contains a repeatable set of an image, title, and summary fields.

| Property                             | Description                                                                                                                                                                              |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <strong>non-repeatable</strong><br/> | <p>None</p>                                                                                                                                                                              |
| <strong>repeatable</strong><br/>     | <p>- An Image field with the API ID of &quot;image&quot;</p><p>- A Title field with the API ID of &quot;title&quot;</p><p>- A Rich Text field with the API ID of &quot;summary&quot;</p> |

### Text slice

The "text" slice contains only a Rich Text field in the non-repeatable section.

| Property                             | Description                                                         |
| ------------------------------------ | ------------------------------------------------------------------- |
| <strong>non-repeatable</strong><br/> | <p>- A Rich Text field with the API ID of &quot;rich_text&quot;</p> |
| <strong>repeatable</strong><br/>     | <p>None</p>                                                         |

### Integration

Here is an example of how to integrate these slices into a landing page.

```
<div class="page-content">
  <% @document["page.body"].slices.each do |slice| %>
    <% case slice.slice_type

       when "faq" %>
          <div class="faq">
            <%= slice.non_repeat["faq_title"].as_html(link_resolver).html_safe %>
            <% slice.repeat.each do |faq| %>
              <div>
                <%= faq["question"].as_html(link_resolver).html_safe %>
                <%= faq["answer"].as_html(link_resolver).html_safe %>
              </div>
            <% end %>
          </div>

      <% when "featured_items" %>
        <div class="featured-items">
          <% slice.repeat.each do |featured_item| %>
            <% image_url = featured_item["image"].url %>
            <div>
              <img src="<%= image_url %>">
              <%= featured_item["title"].as_html(link_resolver).html_safe %>
              <%= featured_item["summary"].as_html(link_resolver).html_safe %>
            </div>
          <% end %>
        </div>

      <% when "text" %>
        <div class="text">
          <%= slice.non_repeat["rich_text"].as_html(link_resolver).html_safe %>
        </div>

    <% end %>
  <% end %>
</div>
```
