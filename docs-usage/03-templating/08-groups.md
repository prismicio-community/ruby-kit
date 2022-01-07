# Templating the Group field

The Group field is used to create a repeatable collection of fields.

## Repeatable Group

### Looping through the Group content

Here’s how to integrate a repeatable Group field into your templates. Loop through each item in the group as shown in the following example.

```
<ul>
  <% @document["blog-post.references"].each do |link| %>
    <li>
      <a href="<%= link["link"].url %>">
        <%= link["label"].as_text %>
      </a>
    </li>
  <% end %>
</ul>
```

### Another Example

Here's another example that shows how to integrate a group of images (e.g. a photo gallery) into a page.

```
<div class="photo-gallery">
  <% @document["page.photo-gallery"].each do |image| %>
    <div class="image-with-caption">
      <img src="<%= image["photo"].url %>" />
      <span class="caption">
        <%= image["caption"].as_text %>
      </span>
    </li>
  <% end %>
</div>
```

## Non-repeatable Group

Even if the group is non-repeatable, the Group field will be an array. You simply need to get the first (and only) group in the array and you can retrieve the fields in the group like any other.

Here is an example showing how to integrate the fields of a non-repeatable Group into your templates.

```
<% banner = @document["page.banner_group"].get(0) %>
<div class="banner">
  <img src="<%= banner["banner_image"].url %>" />
  <p><%= banner["banner_text"].as_text %></p>
  <a href="<%= banner["link"].url(link_resolver) %>">
    <%= banner["link_label"].as_text %>
  </a>
</div>
```
