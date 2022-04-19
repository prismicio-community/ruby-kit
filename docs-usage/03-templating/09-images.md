# Templating the Image field

The Image field allows content writers to upload an image that can be configured with size constraints and responsive image views.

## Get the image url

The easiest way to integrate an image is to retrieve and add the image url to an image element.

The following integrates a page's illustration image field.

```html
<img src="<%= @document["page.illustration"].url %>" />
```

### Example with a caption

Here's an example that integrates an illustration with a caption.

```html
<img src="<%= @document["page.illustration"].url %>" />
<span class="image-caption"><%= @document["page.caption"].as_text %></span>
```

## Output as HTML

The `as_html`  method will convert and output the Image as an HTML image element.

```html
<%= @document["page.illustration"].as_html.html_safe %>
```

## Get a responsive image view

The `get_view`  method allows you to retrieve and use your responsive image views. Simply pass the name of the view into the `get_view`  method and use it like any other image fragment.

Here is how to add responsive images using the HTML picture element.

```html
<% main_view = @document["page.responsive-image"] tablet_view =
@document["page.responsive-image"].get_view("tablet") mobile_view =
@document["page.responsive-image"].get_view("mobile") %>

<picture>
  vsource media="(max-width: 400px)", srcset="<%= mobile_view.url %>" />
  <source media="(max-width: 900px)" , srcset="<%= tablet_view.url %>" />
  <source srcset="<%= main_view.url %>" />
  <image src="<%= main_view.url %>" />
</picture>
```

## Add alt or copyright text to your image

### The main image

If you added an alt or copyright text value to your image, you retrieve and apply it as follows.

```html
<% image_url = @document["page.image"].url image_alt =
@document["page.image"].alt image_copyright = @document["page.image"].copyright
%>
<img
  src="<%= image_url %>"
  alt="<%= image_alt %>"
  copyright="<%= image_copyright %>"
/>
```

### An image view

Here's how to retrieve the alt or copyright text for a responsive image view. Note that the alt and copyright text will be the same for all views.

```html
<% mobile_view = @document["page.image"].get_view("mobile") mobile_url =
mobile_view.url mobile_alt = mobile_view.alt mobile_copyright =
mobile_view.copyright %>
<img
  src="<%= mobile_url %>"
  alt="<%= mobile_alt %>"
  copyright="<%= mobile_copyright %>"
/>
```

## Get the image width & height

### The main image

You can retrieve the main image's width or height as shown below.

```javascript
image_width = @document["article.featured-image"].width
image_height = @document["article.featured-image"].height
```

### An image view

Here is how to retrieve the width and height for a responsive image view.

```javascript
mobile_view = @document["article.featured-image"].get_view("mobile")
mobile_width = mobile_view.width
mobile_height = mobile_view.height
```
